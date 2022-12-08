# frozen_string_literal: true

class CreateNotificationPushDeviceAssignments < ActiveRecord::Migration[5.2]
  def change
    create_table :notification_push_device_assignments do |t|
      t.integer :notification_push_id
      t.integer :notification_device_id

      t.timestamps
    end
  end
end
