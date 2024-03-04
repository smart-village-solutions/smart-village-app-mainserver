# frozen_string_literal: true

class Conversation < ApplicationRecord
  belongs_to :conversationable, polymorphic: true
  has_many :conversation_participants
  has_many :members, through: :conversation_participants
end
