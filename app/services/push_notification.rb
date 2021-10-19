# frozen_string_literal: true

# message_options = {
#   title: push_title,
#   body: push_body,
#   data: {
#     id: id,
#     query_type: self.class.to_s
#   }
# }
class PushNotification
  def self.send_notification(device, message_options = {})
    SendSinglePushNotificationJob.perform_later(device.token, message_options)
  end

  def self.send_notifications(message_options = {})
    Notification::Device.all.each do |device|
      send_notification(device, message_options)
    end
  end
end
