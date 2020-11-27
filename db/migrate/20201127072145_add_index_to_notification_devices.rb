class AddIndexToNotificationDevices < ActiveRecord::Migration[5.2]
  def change
    add_index "notification_devices", ["token"], unique: true
  end
end
