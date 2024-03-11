# frozen_string_literal: true

class RenameConversationsToMessagingConversations < ActiveRecord::Migration[6.1]
  def up
    rename_table :conversations, :messaging_conversations
  end

  def down
    rename_table :messaging_conversations, :conversations
  end
end
