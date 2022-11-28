# frozen_string_literal: true

class AddContentFieldsForNotificationPushes < ActiveRecord::Migration[5.2]
  def change
    add_column :notification_pushes, :title, :string
    add_column :notification_pushes, :body, :string
    add_column :notification_pushes, :data, :text
  end
end
