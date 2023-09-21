# frozen_string_literal: true

module RedisAdapter
  class << self


    #-- GTFS Data --#
    #---------------#

    def get_gtfs_calendar_dates(service_id, date, data_provider_id)
      redis.get("#{namespace}:gtfs:#{data_provider_id}:calendar_dates:#{service_id}:#{date}")
    end

    def set_gtfs_calendar_dates(service_id, date, exception_type, data_provider_id)
      redis.set("#{namespace}:gtfs:#{data_provider_id}:calendar_dates:#{service_id}:#{date}", exception_type)
    end

    # get service
    def get_gtfs_calendar(service_id, data_provider_id)
      service_data = redis.get("#{namespace}:gtfs:#{data_provider_id}:calendar:#{service_id}")
      JSON.parse(service_data).to_h if service_data.present?
    end

    # set service
    def set_gtfs_calendar(service_id, service_data, data_provider_id)
      redis.set("#{namespace}:gtfs:#{data_provider_id}:calendar:#{service_id}", service_data.to_json)
    end

    # get route data
    def get_gtfs_route(route_id, data_provider_id)
      route_data = redis.get("#{namespace}:gtfs:#{data_provider_id}:route:#{route_id}")
      JSON.parse(route_data).to_h if route_data.present?
    end

    # set route data
    def set_gtfs_route(route_id, route_data, data_provider_id)
      redis.set("#{namespace}:gtfs:#{data_provider_id}:route:#{route_id}", route_data.to_json)
    end

    # get all Trip IDs
    def get_gtfs_route_ids(data_provider_id)
      redis.lrange("#{namespace}:gtfs:#{data_provider_id}:route_ids", 0, -1)
    end

    def set_gtfs_route_ids(route_id, data_provider_id)
      redis.rpush("#{namespace}:gtfs:#{data_provider_id}:route_ids", route_id)
    end

    # load StopTimes for POI
    def get_gtfs_stop_times(stop_id, data_provider_id)
      stop_time_data = redis.lrange("#{namespace}:gtfs:#{data_provider_id}:stop:#{stop_id}:stop_times", 0, -1)
      stop_time_data.map { |stop_time| JSON.parse(stop_time) }.map(&:to_h)
    end

    def set_gtfs_stop_times(stop_id, stop_times, data_provider_id)
      redis.rpush("#{namespace}:gtfs:#{data_provider_id}:stop:#{stop_id}:stop_times", stop_times.to_json)
    end

    # Trip Data
    def get_gtfs_trip(trip_id, data_provider_id)
      trip_data = redis.get("#{namespace}:gtfs:#{data_provider_id}:trip:#{trip_id}")
      JSON.parse(trip_data).to_h if trip_data.present?
    end

    def set_gtfs_trip(trip_id, trip_data, data_provider_id)
      redis.set("#{namespace}:gtfs:#{data_provider_id}:trip:#{trip_id}", trip_data.to_json)
    end

    # get all Trip IDs
    def get_gtfs_trip_ids(data_provider_id)
      redis.lrange("#{namespace}:gtfs:#{data_provider_id}:trip_ids", 0, -1)
    end

    # store a new trip id
    def set_gtfs_trip_ids(trip_id, data_provider_id)
      redis.rpush("#{namespace}:gtfs:#{data_provider_id}:trip_ids", trip_id)
    end

    #-- Event List Date --#
    #---------------------#

    def set_event_list_date(event_id, list_date)
      expires_in = Time.zone.now.end_of_day.to_i - Time.zone.now.to_i
      redis.set("#{namespace}:event_list_date_for_id:#{event_id}", list_date)
      redis.expire("#{namespace}:event_list_date_for_id:#{event_id}", expires_in)
    end

    def get_event_list_date(event_id)
      redis.get("#{namespace}:event_list_date_for_id:#{event_id}")
    end

    # Store Logs for a Push notification per device token.
    # Old logs will be deleted after a defined timespan
    #
    # @param [String] device_token
    # @param [Hash] message {date: DaeTime, title: "", body: "", payload: ""}
    #
    def add_push_log(device_token, message)
      redis.rpush("#{namespace}:push_log:#{device_token}", message.to_json)
      redis.expire("#{namespace}:push_log:#{device_token}", 96.hours.to_i)
    rescue
      nil
    end

    # Load list of Push Logs for a single device
    def get_push_logs_for_device(device_token)
      redis.lrange("#{namespace}:push_log:#{device_token}", 0, -1)
    rescue
      []
    end

    def get_push_logs
      log_keys = redis.keys("#{namespace}:push_log:*")
      log_keys.inject({}) do |result, log_key|
        result[log_key.split(":").last] = redis.lrange(log_key, 0, -1)
        result
      end
    rescue => e
      { error: [{ title: 'Redis error', body: e }.to_json] }
    end

    #-- Basic connection and namespace --#
    #------------------------------------#

    def redis
      @redis ||= Redis.new(driver: :hiredis, host: Rails.application.credentials.redis[:host], timeout: 2)
    end

    def namespace
      @namespace ||= Rails.application.credentials.redis[:namespace]
    end
  end
end
