# frozen_string_literal: true

class RenameMessagesToMessagingMessages < ActiveRecord::Migration[6.1]
  def up
    rename_table :messages, :messaging_messages
  end

  def down
    rename_table :messaging_messages, :messages
  end
end
