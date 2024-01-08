# frozen_string_literal: true

class RedisAdapters::DataResource
  attr_reader :redis, :namespace

  def initialize
    municipality_settings = MunicipalityService.settings
    @redis = Redis.new(driver: :hiredis, host: municipality_settings[:redis_host], timeout: 10)
    @namespace = municipality_settings[:redis_namespace]
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
end
