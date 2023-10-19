class AddExcludeMowasRegionalKeysToNotificationDevices < ActiveRecord::Migration[5.2]
  def change
    add_column :notification_devices, :exclude_mowas_regional_keys, :text
  end
end
