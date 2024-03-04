# frozen_string_literal: true

class CreateConversationParticipants < ActiveRecord::Migration[6.1]
  def change
    create_table :conversation_participants do |t|
      t.references :conversation, null: false, foreign_key: true
      t.references :member, null: false, foreign_key: true
      t.boolean :email_notification_enabled, default: true
      t.boolean :push_notification_enabled, default: true

      t.timestamps
    end
  end
end
