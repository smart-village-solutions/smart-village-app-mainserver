# frozen_string_literal: true

class Messaging::Conversation < ApplicationRecord
  belongs_to :conversationable, polymorphic: true
  has_many :messages, class_name: "Messaging::Message"
  has_many :conversation_participants, class_name: "Messaging::ConversationParticipants"
  has_many :members, through: :conversation_participants
end
