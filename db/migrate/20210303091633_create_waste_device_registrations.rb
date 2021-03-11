class CreateWasteDeviceRegistrations < ActiveRecord::Migration[5.2]
  def change
    create_table :waste_device_registrations do |t|
      t.string :notification_device_token
      t.string :street
      t.string :city
      t.string :zip
      t.integer :notify_days_before, default: 0
      t.time :notify_at
      t.string :notify_for_waste_type

      t.timestamps
    end
  end
end
