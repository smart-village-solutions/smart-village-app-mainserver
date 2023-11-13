# frozen_string_literal: true

class GtfsRedisAdapter
  attr_reader :redis, :namespace

  def initialize
    @redis = Redis.new(driver: :hiredis, host: Rails.application.credentials.redis[:host], timeout: 10)
    @namespace = Rails.application.credentials.redis[:namespace]
  end

  def get_gtfs_calendar_dates(service_id, date, data_provider_id)
    redis.get("#{namespace}:gtfs:#{data_provider_id}:calendar_dates:#{service_id}:#{date}")
  end

  def set_gtfs_calendar_dates(service_id, date, exception_type, data_provider_id)
    redis.set("#{namespace}:gtfs:#{data_provider_id}:calendar_dates:#{service_id}:#{date}", exception_type)
  end

  # delete all key starting with calendar_dates
  def delete_all_gtfs_calendar_dates(data_provider_id)
    redis.scan_each(match: "#{namespace}:gtfs:#{data_provider_id}:calendar_dates:*") do |key|
      redis.del(key)
    end
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

  def delete_all_gtfs_calendar(data_provider_id)
    redis.scan_each(match: "#{namespace}:gtfs:#{data_provider_id}:calendar:*") do |key|
      redis.del(key)
    end
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

  # delete all key starting with stop
  def delete_all_stop_times(data_provider_id)
    redis.scan_each(match: "#{namespace}:gtfs:#{data_provider_id}:stop:*") do |key|
      redis.del(key)
    end
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
end
