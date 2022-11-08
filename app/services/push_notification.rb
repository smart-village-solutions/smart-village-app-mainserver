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
    notification_devices(message_options).each do |device|
      send_notification(device, message_options)
    end
  end

  private

    # if there is a data provider id given, check if there are devices with individual settings
    # for excluding data providers and filter them out eventually
    def notification_devices(message_options = {})
      data_provider_id = message_options[:data_provider_id]

      if data_provider_id.present?
        return Notification::Device.where(
          "exclude_data_provider_ids IS NULL OR exclude_data_provider_ids NOT LIKE '%- ?\n%'",
          data_provider_id
        )
      end

      Notification::Device.all
    end
end
