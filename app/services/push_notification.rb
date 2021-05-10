# frozen_string_literal: true

class PushNotification
  # message_options = {
  #   title: push_title,
  #   body: push_body,
  #   data: {
  #     id: 23,
  #     query_type: 'news_item'
  #   }
  # }

  def self.send_notifications(message_options = {})
    client = Exponent::Push::Client.new
    resource_id = message_options.dig(:data, :id)
    resource_name = message_options.dig(:data, :query_type)
    return if resource_id.present? && resource_name.present? && RedisAdapter.check_push_lock(resource_name, resource_id) == "locked"

    RedisAdapter.lock_push_notification(resource_name, resource_id, 1.hour)
    Notification::Device.all.each do |device|
      device_token = device.token

      # Send PushNotification
      messages = [message_options.merge(to: device_token)]
      feedback = client.send_messages(messages)

      # Log PushNotification
      RedisAdapter.add_push_log(device_token, message_options.merge(date: DateTime.now, payload: feedback.try(:response).try(:body)))
    end
  end
end
