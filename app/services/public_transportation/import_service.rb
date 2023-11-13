require "rubygems"
require "zip"
require "csv"
require "benchmark"
require "net/http"
require "uri"

# Zipfile including following files:
# - agency.txt
# - calendar.txt
# - calendar_dates.txt
# - frequencies.txt
# - routes.txt
# - service_alerts.txt
# - shapes.txt
# - stop_times.txt
# - stops.txt
# - transfers.txt
# - trips.txt
class PublicTransportation::ImportService
  def initialize(gtfs_url, data_provider_id, whitelist_poi = [])
    @gtfs_url = gtfs_url
    @data_provider_id = data_provider_id
    @gtfs_config = StaticContent.find_by(name: "gtfsConfig").try(:content)
    @gtfs_config = JSON.parse(@gtfs_config) if @gtfs_config.present?
    @whitelist = whitelist_poi.map(&:to_i) if whitelist_poi.present?
    @pois = {}
    @redis = GtfsRedisAdapter.new
    @import_from_calender_date = (Date.today - (1.day)).strftime("%Y%m%d")
  end

  def call
    namespace_key = "gtfs-#{Time.zone.now.strftime('%Y%m%d%H%M%S')}"
    @zip_file_path = Rails.root.join("tmp", "#{namespace_key}.zip")
    response = fetch_url(@gtfs_url)
    if response.is_a?(Net::HTTPSuccess)
      File.open(@zip_file_path, 'wb') do |output_file|
        output_file.write(response.body)
      end
    else
      p "Ein Fehler ist aufgetreten: #{response.message}"
    end

    # abbrechen wenn die Temp Datei nicht existiert oder leer ist
    return unless File.exist?(@zip_file_path)
    return if File.zero?(@zip_file_path)

    ::Zip::File.open(@zip_file_path) do |zip_file|
      # parse calendar.txt
      benchmark = Benchmark.measure do
        parse_calendar(zip_file)
      end
      p "Zeit für die Ausführung Calendar: #{benchmark.real} Sekunden"

      # parse stops.txt
      benchmark = Benchmark.measure do
        parse_stops(zip_file)
      end
      p "Zeit für die Ausführung POI Import: #{benchmark.real} Sekunden"

      # parse stop_times.txt
      benchmark = Benchmark.measure do
        parse_stop_times(zip_file)
      end
      p "Zeit für die Ausführung StopTimes: #{benchmark.real} Sekunden"

      # parse trips.txt
      benchmark = Benchmark.measure do
        parse_trips(zip_file)
      end
      p "Zeit für die Ausführung Trips: #{benchmark.real} Sekunden"

      # parse routes.txt
      benchmark = Benchmark.measure do
        parse_routes(zip_file)
      end
      p "Zeit für die Ausführung Routes: #{benchmark.real} Sekunden"

      # parse calendar_dates.txt
      benchmark = Benchmark.measure do
        parse_calendar_dates(zip_file)
      end
      p "Zeit für die Ausführung CalendarDates: #{benchmark.real} Sekunden"
    end

    # delete temp file
    File.delete(@zip_file_path) if File.exist?(@zip_file_path)

    self
  end

  private

    def parse_calendar_dates(zip_file)
      p "Parsing calendar_dates.txt"
      calendar_dates_counter = 0

      # cleanup calendar_dates before import
      @redis.delete_all_gtfs_calendar_dates(@data_provider_id)

      parse_file_of_zip(zip_file, "calendar_dates.txt") do |parsed_line|
        next if parsed_line["date"].to_i < @import_from_calender_date.to_i

        @redis.set_gtfs_calendar_dates(
          parsed_line["service_id"],
          parsed_line["date"],
          parsed_line["exception_type"],
          @data_provider_id
        )
        calendar_dates_counter += 1
      end
      p "Found #{calendar_dates_counter} CalendarDates in calendar_dates.txt"
    end

    def parse_calendar(zip_file)
      p "Parsing calendar.txt"
      calendar_counter = 0

      # cleanup calendar before import
      @redis.delete_all_gtfs_calendar(@data_provider_id)

      parse_file_of_zip(zip_file, "calendar.txt") do |parsed_line|
        @redis.set_gtfs_calendar(parsed_line["service_id"], parsed_line, @data_provider_id)
        calendar_counter += 1
      end
      p "Found #{calendar_counter} Calendars in calendar.txt"
    end

    def parse_routes(zip_file)
      p "Parsing routes.txt"
      route_counter = 0
      route_ids_of_trips = @redis.get_gtfs_route_ids(@data_provider_id)
      parse_file_of_zip(zip_file, "routes.txt") do |parsed_line|
        route_id = parsed_line["route_id"].to_i
        next unless route_ids_of_trips.include?(route_id.to_s)

        @redis.set_gtfs_route(route_id, parsed_line, @data_provider_id)
        route_counter += 1
      end
      p "Found #{route_counter} Routes in routes.txt"
    end

    def parse_trips(zip_file)
      p "Parsing trips.txt"
      trip_counter = 0
      # trip_ids_of_stop_times = @redis.get_gtfs_trip_ids(@data_provider_id).map(&:to_i)
      parse_file_of_zip(zip_file, "trips.txt") do |parsed_line|
        trip_id = parsed_line["trip_id"].to_i
        # next unless trip_ids_of_stop_times.include?(trip_id)

        @redis.set_gtfs_trip(trip_id, parsed_line, @data_provider_id)
        @redis.set_gtfs_route_ids(parsed_line["route_id"], @data_provider_id)
        trip_counter += 1
      end
      p "Found #{trip_counter} trips in trips.txt"
    end

    def parse_stop_times(zip_file)
      p "Parsing stop_times.txt"
      stop_time_counter = 0

      # cleanup stop_times before import
      @redis.delete_all_stop_times(@data_provider_id)

      parse_file_of_zip(zip_file, "stop_times.txt") do |parsed_line|
        stop_id = parsed_line["stop_id"].to_i
        next unless @pois.keys.include?(stop_id)

        @redis.set_gtfs_trip_ids(parsed_line["trip_id"].to_i, @data_provider_id)
        @redis.set_gtfs_stop_times(stop_id, parsed_line, @data_provider_id)
        stop_time_counter += 1
      end
      p "Found #{stop_time_counter} stops in stop_times.txt"
    end

    # select all stops from stops.txt
    def parse_stops(zip_file)
      p "Parsing stops.txt"
      stop_counter = 0
      parse_file_of_zip(zip_file, "stops.txt") do |parsed_line|
        poi_stop_id = parsed_line["stop_id"].to_i
        next if @whitelist.present? && @whitelist.any? && !@whitelist.include?(poi_stop_id)

        # create a new point of interest or update it
        point_of_interest = PointOfInterest.where(external_id: poi_stop_id.to_s).first_or_initialize
        point_of_interest.name = parsed_line["stop_name"].force_encoding("UTF-8")
        point_of_interest.data_provider_id = @data_provider_id
        point_of_interest.payload = parsed_line.to_h || {}
        point_of_interest.payload["has_travel_times"] = true
        if parsed_line["stop_lat"].present? && parsed_line["stop_lon"].present?
          address = point_of_interest.addresses.first || point_of_interest.addresses.build
          geo_location = address.geo_location || address.build_geo_location
          geo_location.latitude = parsed_line["stop_lat"]
          geo_location.longitude = parsed_line["stop_lon"]
        end
        point_of_interest.save
        @pois[poi_stop_id] = point_of_interest.id
        p "Updating POI id: #{point_of_interest.id}, poi_stop_id: #{poi_stop_id}"

        stop_counter += 1
      end
      p "Found #{stop_counter} stops in stops.txt"
    end

    # method to pars a csv file from a zip file with a given file name
    # and a given block to call with the parsed line
    def parse_file_of_zip(zip_file, file_name)
      data_file = zip_file.glob(file_name).first
      raise "File #{file_name} not found in zip file" if data_file.nil?

      header_data = nil
      data_file.get_input_stream.read.force_encoding("UTF-8").each_line.with_index do |line, index|
        # set csv header and skip in all following lines
        (header_data = CSV.parse(line).first; next) if index.zero?

        # parse line with header_data_line as csv header
        parsed_line = CSV.parse(line, headers: header_data).first

        # Call the given block with the parsed line
        yield(parsed_line) if block_given?
      end
    end

    def fetch_url(uri_str, limit = 10)
      raise ArgumentError, 'HTTP-Weiterleitungs-Schleife' if limit == 0

      uri = URI.parse(uri_str)
      response = Net::HTTP.get_response(uri)

      case response
      when Net::HTTPSuccess then
        response
      when Net::HTTPRedirection then
        location = response['location']
        warn "Weitergeleitet nach #{location}"
        fetch_url(location, limit - 1)
      else
        response.value
      end
    end
end
