# frozen_string_literal: true

class AddOwnerIdToConversations < ActiveRecord::Migration[6.1]
  def change
    add_column :conversations, :owner_id, :bigint, null: false
    add_foreign_key :conversations, :members, column: :owner_id
    add_index :conversations, :owner_id
  end
end
