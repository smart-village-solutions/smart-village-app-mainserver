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
    return unless Rails.env.production?

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

  def schedule_notifications
    check_date = Date.today
    notification_pushes = Notification::Push.all

    notification_pushes.each do |notification_push|
      if notification_push.recurring.zero? && notification_push.once_at.present?
        # if a push notification should be sent once today at a certain time
        next unless check_date.to_s(:date) == notification_push.once_at.strftime("%Y-%m-%d")

        time_to_run = notification_push.once_at.to_s(:time)
      else
        # if a push notification should be sent on todays weekday at a certain time
        check_weekday = check_date.strftime("%A").downcase
        weekday_method = "#{check_weekday}_at".to_sym

        next unless notification_push.methods.include?(weekday_method)

        time_to_run = notification_push.send(weekday_method).to_s(:time)
      end

      # this way we can convert times, that are given as winter because of `time` database field,
      # which serves on first of january, to the local time zone to correct it to summertime
      # if it is summer
      date_time_to_run = Time.zone.parse("#{check_date} #{time_to_run}")
      p "Push notification found for: #{notification_push.notification_pushable_type} ##{notification_push.notification_pushable_id}"
      p "Scheduled at: #{date_time_to_run}"

      next unless Rails.env.production?

      SendSinglePushNotificationJob.delay(run_at: date_time_to_run).perform(device.token, message_options)
    end

    "Notifications scheduled for today"
  end
end
