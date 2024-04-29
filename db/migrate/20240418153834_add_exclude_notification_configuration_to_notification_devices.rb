# frozen_string_literal: true

class AddExcludeNotificationConfigurationToNotificationDevices < ActiveRecord::Migration[6.1]
  def change
    add_column :notification_devices, :exclude_notification_configuration, :text
  end
end
