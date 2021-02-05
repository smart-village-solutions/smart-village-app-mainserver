class AddPushNotificationsSentAtToNewsItems < ActiveRecord::Migration[5.2]
  def change
    add_column :news_items, :push_notifications_sent_at, :datetime
  end
end
