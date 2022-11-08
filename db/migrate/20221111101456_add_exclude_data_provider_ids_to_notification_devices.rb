class AddExcludeDataProviderIdsToNotificationDevices < ActiveRecord::Migration[5.2]
  def change
    add_column :notification_devices, :exclude_data_provider_ids, :text
  end
end
