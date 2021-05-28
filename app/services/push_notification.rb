# frozen_string_literal: true

class PushNotification
  # message_options = {
  #   title: push_title,
  #   body: push_body,
  #   data: {
  #     id: id,
  #     query_type: self.class.to_s
  #   }
  # }

  def self.send_notifications(message_options = {})
    @client = Exponent::Push::Client.new
    Notification::Device.all.each do |device|
      device_token = device.token

      # Send PushNotification
      messages = [message_options.merge(to: device_token)]

      begin
        feedback = @client.send_messages(messages)
        RedisAdapter.add_push_log(device_token, message_options.merge(date: DateTime.now, payload: feedback.try(:response).try(:body)))
      rescue => e
        RedisAdapter.add_push_log(device_token, message_options.merge(rescue_error: "push notification", error: e, date: DateTime.now))
      end
    end
  end
end
