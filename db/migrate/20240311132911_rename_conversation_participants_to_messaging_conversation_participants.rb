# frozen_string_literal: true

class RenameConversationParticipantsToMessagingConversationParticipants < ActiveRecord::Migration[6.1]
  def up
    rename_table :conversation_participants, :messaging_conversation_participants
  end

  def down
    rename_table :messaging_conversation_participants, :conversation_participants
  end
end
