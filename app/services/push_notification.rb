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
      SendSinglePushNotificationJob.perform_later(device_token, message_options)
    end
  end
end
