class AddMemberIdToNotificationDevices < ActiveRecord::Migration[6.1]
  def change
    add_column :notification_devices, :member_id, :integer
  end
end
