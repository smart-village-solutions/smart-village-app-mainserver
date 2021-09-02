class AddBusinessnotificationToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :business_account_outdated_notification_sent_at, :datetime
  end
end
