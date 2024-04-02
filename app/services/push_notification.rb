# frozen_string_literal: true

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
class PushNotification
  def self.send_notification(device, message_options = {})
    return unless Rails.env.production?

    SendSinglePushNotificationJob.perform_later(device.token, message_options)
  end

  def self.send_notifications(message_options = {})
    data = message_options[:data]

    if data.present?
      data_provider_id = data.fetch(:data_provider_id)
      mowas_regional_keys = data.fetch(:mowas_regional_keys, [])
    end

    notification_devices = Notification::Device.all

    if data_provider_id.present?
      notification_devices = notification_devices.where(
        "exclude_data_provider_ids IS NULL OR exclude_data_provider_ids NOT LIKE '%- ?\n%'",
        data_provider_id
      )
    end

    if mowas_regional_keys.present?
      notification_devices = notification_devices.where(
        "NOT (#{mowas_regional_keys.map { "exclude_mowas_regional_keys LIKE '%- ?\n%'" }.join(' AND ')}) OR exclude_mowas_regional_keys IS NULL",
        *mowas_regional_keys
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

        time_to_run = notification_push.send(weekday_method).try(:to_s, :time)
      end

      next unless time_to_run.present?

      # this way we can convert times, that are given as winter because of `time` database field,
      # which serves on first of january, to the local time zone to correct it to summertime
      # if it is summer
      date_time_to_run = Time.zone.parse("#{check_date} #{time_to_run}")
      p "Push notification found for: #{notification_push.notification_pushable_type} ##{notification_push.notification_pushable_id}"
      p "Scheduled at: #{date_time_to_run}"

      message_options = {
        title: notification_push.title,
        body: notification_push.body,
        data: notification_push.data
      }

      # get all devices to push to
      devices = notification_push.devices

      p "For #{devices.count} device(s)"

      devices.each do |device|
        next if existing_notifications_count(device, message_options).positive?

        # next unless Rails.env.production?

        SendSinglePushNotificationJob.delay(run_at: date_time_to_run).perform(device.token, message_options)
      end
    end

    "Notifications scheduled for today"
  end

  private

    # Lookup for existing notifications
    def existing_notifications_count(device, message_options = {})
      Delayed::Backend::ActiveRecord::Job
        .where("handler LIKE '%SendSinglePushNotificationJob%'")
        .where("handler LIKE '%args:\n- #{device.token}%'")
        .where("handler LIKE '%\n- :title: #{message_options.dig(:title)}%'")
        .where("handler LIKE '%\n  :body: #{message_options.dig(:body)}%'")
        .where("handler LIKE '%\n    :id: #{message_options.dig(:data, :id)}%'")
        .where("handler LIKE '%\n    :query_type: #{message_options.dig(:data, :query_type)}%'")
        .count
    end
end
