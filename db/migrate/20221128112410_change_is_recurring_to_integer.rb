# frozen_string_literal: true

class ChangeIsRecurringToInteger < ActiveRecord::Migration[5.2]
  def up
    remove_column :notification_pushes, :is_recurring
    add_column :notification_pushes, :recurring, :integer, default: 0
  end

  def down
    remove_column :notification_pushes, :recurring
    add_column :notification_pushes, :is_recurring, :boolean, default: 0
  end
end
