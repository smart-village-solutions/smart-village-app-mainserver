# frozen_string_literal: true

module RedisAdapter
  class << self

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
    # ---------------------------------- #

    def redis
      @redis ||= Redis.new(driver: :hiredis, host: Settings.redis[:host], timeout: 2)
    end

    def namespace
      @namespace ||= Settings.redis[:namespace]
    end
  end
end
