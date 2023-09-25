# get travel times for a specific date
# GTFS field descriptions: https://developers.google.com/transit/gtfs?hl=de
#
# @param [String] date "2023-09-18T12:00"
#
# @return [JSON] [
#   {
#     "stop_sequence": "26",
#     "stop_headsign": "",
#     "pickup_type": "0",
#     "drop_off_type": "0",
#     "arrival_time": "12:06:00",
#     "departure_time": "12:06:00",
#     "trip": {
#       "trip_headsign": "Name der Endhaltestelle",
#       "trip_short_name": "00772",
#       "direction_id": "0",
#       "wheelchair_accessible": "1",
#       "bikes_allowed": "0"
#     },
#     "route": {
#       "route_short_name": "24",
#       "route_long_name": "",
#       "route_type": "3",
#       "route_color": "951b81",
#       "route_text_color": "ffffff",
#       "route_desc": ""
#     }
#   }
# ]
class PublicTransportation::TravelTime
  def initialize(date:, external_id:, data_provider_id:)
    @date = date
    @external_id = external_id
    @data_provider_id = data_provider_id

    travel_date = DateTime.parse(@date)
    @weekday = travel_date.strftime("%A").downcase
    @calendar_exception_date = travel_date.strftime("%Y%m%d")
    @travel_time_from = travel_date.strftime("%H:%M:%S")

    @calculated_travel_times = []
    @redis = GtfsRedisAdapter.new
  end

  def travel_times
    return [] if @external_id.blank?

    stop_times = @redis.get_gtfs_stop_times(@external_id, @data_provider_id)
    stop_times.each do |stop_time|
      begin
        stop_time_data = gtfs_stop_time_data(stop_time)
        trip = @redis.get_gtfs_trip(stop_time["trip_id"], @data_provider_id)
        if trip.present?
        stop_time_data["trip"] = gtfs_trip_data(trip)
        stop_time_data["route"] = gtfs_route(trip["route_id"])

        traveling = gtfs_calendar(stop_time, trip["service_id"])
        @calculated_travel_times << stop_time_data if traveling
        end
      rescue => e
        p "Error: #{e.message}, #{e.backtrace.first}"
        # do nothing
      end
    end

    @calculated_travel_times
  end

  private

    def gtfs_calendar(stop_time, service_id)
      gtfs_cal_data = @redis.get_gtfs_calendar(service_id, @data_provider_id)
      traveling = gtfs_cal_data[@weekday].to_i
      exception = @redis.get_gtfs_calendar_dates(service_id, @calendar_exception_date, @data_provider_id) || nil

      case exception.to_i
      when 1
        traveling = 1
      when 2
        traveling = 0
      end

      traveling = 0 if @calendar_exception_date.to_i < gtfs_cal_data["start_date"].to_i
      traveling = 0 if @calendar_exception_date.to_i > gtfs_cal_data["end_date"].to_i

      # check if travel time is after departure time
      # departure_time kann auch "24:14" sein
      begin
        departure_time = Time.parse(stop_time["departure_time"])
        travel_time_from = Time.parse(@travel_time_from)
        traveling = 0 if departure_time.to_i < travel_time_from.to_i
      rescue
        # do nothing
      end

      traveling == 1
    end

    def gtfs_route(route_id)
      route_data = @redis.get_gtfs_route(route_id, @data_provider_id)

      {
        route_short_name: route_data["route_short_name"],
        route_long_name: route_data["route_long_name"],
        route_type: route_data["route_type"],
        route_color: route_data["route_color"],
        route_text_color: route_data["route_text_color"],
        route_desc: route_data["route_desc"]
      }
    end

    def gtfs_trip_data(trip)
      {
        trip_headsign: trip["trip_headsign"],
        trip_short_name: trip["trip_short_name"],
        direction_id: trip["direction_id"],
        wheelchair_accessible: trip["wheelchair_accessible"],
        bikes_allowed: trip["bikes_allowed"]
      }
    end

    def gtfs_stop_time_data(stop_time)
      {
        stop_sequence: stop_time["stop_sequence"],
        stop_headsign: stop_time["stop_headsign"],
        pickup_type: stop_time["pickup_type"],
        drop_off_type: stop_time["drop_off_type"],
        arrival_time: stop_time["arrival_time"],
        departure_time: stop_time["departure_time"]
      }
    end
end
