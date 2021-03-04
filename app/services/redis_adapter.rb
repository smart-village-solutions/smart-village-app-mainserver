# frozen_string_literal: true

module RedisAdapter
  class << self

    # Stor Logs for a Push notification per device token
    #
    # @param [String] device_token
    # @param [Hash] message {date: DaeTime, title: "", body: "", payload: ""}
    #
    # @return [<Type>] <description>
    def add_push_log(device_token, message)
      redis.rpush("#{namespace}:push_log:#{device_token}", message.to_json)
      redis.expire("#{namespace}:push_log:#{device_token}", 7200)
    rescue
      nil
    end

    def get_push_log_for_device(device_token)
      redis.lrange("#{namespace}:push_log:#{device_token}", 0, -1)
    rescue
      nil
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
