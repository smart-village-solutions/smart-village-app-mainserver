# frozen_string_literal: true

class AddPushNotificationsSentAtToResources < ActiveRecord::Migration[6.1]
  def up
    add_column :event_records, :push_notifications_sent_at, :datetime
    add_column :attractions, :push_notifications_sent_at, :datetime
  end

  def down
    remove_column :event_records, :push_notifications_sent_at
    remove_column :attractions, :push_notifications_sent_at
  end
end
