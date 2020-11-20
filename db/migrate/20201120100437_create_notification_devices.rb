class CreateNotificationDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :notification_devices do |t|
      t.string :token
      t.integer :device_type, default: 0

      t.timestamps
    end
  end
end
