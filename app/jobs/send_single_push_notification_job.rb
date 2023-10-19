# frozen_string_literal: true

class SendSinglePushNotificationJob < ApplicationJob
  queue_as :default

  # device_token = "ExponentPushToken[RkCuwM123456778g29lQb0ZK]"
  # message_options = {
  #   title: push_title,
  #   body: push_body,
  #   data: {
  #     id: id,
  #     query_type: self.class.to_s,
  #     data_provider_id: data_provider.id,
  #     payload: payload
  #   }
  # }
  def send_single_push_notification(device_token, message_options)
    client = Exponent::Push::Client.new
    messages = [message_options.merge(to: device_token)]

    begin
      feedback = client.send_messages(messages)
      payload = feedback.try(:response).try(:body)

      RedisAdapter.add_push_log(
        device_token,
        message_options.merge(date: DateTime.now, payload: payload)
      )

      cleanup_if_unregistered_device(device_token, payload)
    rescue StandardError => e
      RedisAdapter.add_push_log(
        device_token,
        message_options.merge(rescue_error: "push notification", error: e, date: DateTime.now)
      )
    end
  end

  def self.send_single_push_notification(device_token, message_options)
    client = Exponent::Push::Client.new
    messages = [message_options.merge(to: device_token)]

    begin
      feedback = client.send_messages(messages)
      payload = feedback.try(:response).try(:body)

      RedisAdapter.add_push_log(
        device_token,
        message_options.merge(date: DateTime.now, payload: payload)
      )

      cleanup_if_unregistered_device(device_token, payload)
    rescue StandardError => e
      RedisAdapter.add_push_log(
        device_token,
        message_options.merge(rescue_error: "push notification", error: e, date: DateTime.now)
      )
    end
  end

  def perform(device_token, message_options)
    send_single_push_notification(device_token, message_options)
  end

  def self.perform(device_token, message_options)
    send_single_push_notification(device_token, message_options)
  end

  def cleanup_if_unregistered_device(device_token, payload)
    return if payload.blank?

    payload = JSON.parse(payload)
    data = payload["data"]

    return if data.blank?
    return unless data.is_a?(Array)

    data.each do |entry|
      next unless entry["status"] == "error"
      next unless entry["message"] == "The recipient device is not registered with FCM."

      details = entry["details"]

      next if details.blank?
      next unless details["error"] == "DeviceNotRegistered"

      Notification::Device.where(token: device_token).destroy_all
    end
  end
end
