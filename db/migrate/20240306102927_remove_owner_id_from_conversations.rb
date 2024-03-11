# frozen_string_literal: true

class RemoveOwnerIdFromConversations < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :conversations, column: :owner_id
    remove_index :conversations, :owner_id
    remove_column :conversations, :owner_id
  end
end
