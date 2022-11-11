# frozen_string_literal: true

# message_options = {
#   title: push_title,
#   body: push_body,
#   data: {
#     id: id,
#     query_type: self.class.to_s,
#     data_provider_id: data_provider.id
#   }
# }
class PushNotification
  def self.send_notification(device, message_options = {})
    SendSinglePushNotificationJob.perform_later(device.token, message_options)
  end

  def self.send_notifications(message_options = {})
    notification_devices = Notification::Device.all
    data_provider_id = message_options[:data_provider_id]

    if data_provider_id.present?
      notification_devices = Notification::Device.where(
        "exclude_data_provider_ids IS NULL OR exclude_data_provider_ids NOT LIKE '%- ?\n%'",
        data_provider_id
      )
    end

    notification_devices.each do |device|
      send_notification(device, message_options)
    end
  end
end
