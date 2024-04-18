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
  def self.send_notification(device, message_options = {}, municipality_id)
    return unless Rails.env.production?

    SendSinglePushNotificationJob.perform_later(device.token, message_options, municipality_id)
  end

  def self.send_notifications(message_options = {}, municipality_id = nil)
    MunicipalityService.municipality_id = municipality_id

    data = message_options[:data]

    if data.present?
      data_provider_id = data.fetch(:data_provider_id)
      mowas_regional_keys = data.fetch(:mowas_regional_keys, [])

      categories_ids = data.fetch(:categories_ids, [])
      point_of_interest_id = data.fetch(:poi_id, nil)
      pn_config_klass = data.fetch(:pn_config_klass, nil)
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

    if categories_ids.present? || point_of_interest_id.present? || data_provider_id.present?
      notification_devices = notification_devices.reject do |device|
        check_pn_config(device, categories_ids, data_provider_id, point_of_interest_id, pn_config_klass)
      end
    end

    notification_devices.each do |device|
      send_notification(device, message_options, municipality_id)
    end
  end

  # rubocop:disable all
  def check_pn_config(device, resource_categories_ids, resource_dp_id, resource_poi_id, resource_klass)
    configs = device.pn_configuration[pn_config_klass]
    return false if configs.blank?

    configs.any? do |category_ids, dp_poi_ids|
      category_ids = category_ids.to_s.split("_").map(&:to_i)
      with_descendant_ids = Category.where(id: category_ids).map(&:subtree_ids).flatten.uniq

      dp_ids, poi_ids = extract_ids_from_exclusions(dp_poi_ids)

      next false if (with_descendant_ids & resource_categories_ids).blank?

      next true if data_provide_ids.blank? && poi_ids.blank?

      is_data_match = dp_ids.present? && resource_dp_id.present? && dp_ids.include?(resource_dp_id)
      is_point_match = poi_ids.present? && resource_poi_id.prsent? && poi_ids.include?(resource_poi_id)

      is_data_match || is_point_match
    end
  end

  def self.perform_schedule
    p "PushNotificationJob started at #{Time.zone.now}"
    Municipality.all.each do |municipality|
      MunicipalityService.municipality_id = municipality.id
      p "PushNotificationJob for municipality #{municipality.id}"
      PushNotification.new.schedule_notifications
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

        SendSinglePushNotificationJob.delay(run_at: date_time_to_run).perform(
          device.token,
          message_options,
          MunicipalityService.municipality_id
        )
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

    def extract_ids_from_exclusions(exclusions)
      data_provider_ids = exclusions.filter_map { |e| e.delete_prefix("dp_").to_i if e.start_with?("dp_") }
      poi_ids = exclusions.filter_map { |e| e.delete_prefix("poi_").to_i if e.start_with?("poi_") }
      [data_provider_ids, poi_ids]
    end

    def resource_based_configuration(device, resource_klass)
      device.exclude_notification_configuration[resource_klass.to_sym]
    end
end
