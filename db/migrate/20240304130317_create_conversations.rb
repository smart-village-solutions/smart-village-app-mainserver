# frozen_string_literal: true

class CreateConversations < ActiveRecord::Migration[6.1]
  def change
    create_table :conversations do |t|
      t.references :conversationable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
