# frozen_string_literal: true

class PushNotification
  attr_accessor :client, :message_options

  # message_options = {
  #   title: push_title,
  #   body: push_body,
  #   data: {
  #     id: id,
  #     query_type: self.class.to_s
  #   }
  # }
  def initialize(message_options = {})
    @client = Exponent::Push::Client.new
    @message_options = message_options
  end

  def send_notifications
    Notification::Device.all.each do |device|
      # Send PushNotification
      messages = [message_options.merge(to: device.token)]
      feedback = @client.send_messages(messages)

      # Log PushNotification
      RedisAdapter.add_push_log(device.token, message_options.merge(date: DateTime.now, payload: feedback))
    end
  end
end
