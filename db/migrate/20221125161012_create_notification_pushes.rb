# frozen_string_literal: true

class CreateNotificationPushes < ActiveRecord::Migration[5.2]
  def change
    create_table :notification_pushes do |t|
      t.string :notification_pushable_type
      t.bigint :notification_pushable_id
      t.datetime :once_at
      t.boolean :is_recurring, default: false
      t.time :monday_at
      t.time :tuesday_at
      t.time :wednesday_at
      t.time :thursday_at
      t.time :friday_at
      t.time :saturday_at
      t.time :sunday_at

      t.timestamps
    end
  end
end
