# frozen_string_literal: true

module RedisAdapter
  class << self

    # create a lock entry for a resource and a given timespan.
    # Lock entry will be delete automatic after given timespan.
    #
    # @param [String] resource_name
    # @param [Integer] resource_id
    # @param [Timespan] ttl (e.g. 5.minutes)
    #
    def lock_push_notification(resource_name, resource_id, ttl = 5.minutes)
      redis.set("#{namespace}:lock_push:#{resource_name}:#{resource_id}", "locked")
      redis.expire("#{namespace}:lock_push:#{resource_name}:#{resource_id}", ttl)
    end

    # check if there is an lock entry for a given resource name and id
    def check_push_lock(resource_name, resource_id)
      redis.get("#{namespace}:lock_push:#{resource_name}:#{resource_id}")
    end

    # Store Logs for a Push notification per device token.
    # Old logs will be deleted after a defined timespan
    #
    # @param [String] device_token
    # @param [Hash] message {date: DaeTime, title: "", body: "", payload: ""}
    #
    def add_push_log(device_token, message)
      redis.rpush("#{namespace}:push_log:#{device_token}", message.to_json)
      redis.expire("#{namespace}:push_log:#{device_token}", 24.hours.to_i)
    rescue
      nil
    end

    def get_push_log_for_device(device_token)
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
    # ---------------------------------- #

    def redis
      @redis ||= Redis.new(driver: :hiredis, host: Rails.application.credentials.redis[:host], timeout: 2)
    end

    def namespace
      @namespace ||= Rails.application.credentials.redis[:namespace]
    end
  end
end
