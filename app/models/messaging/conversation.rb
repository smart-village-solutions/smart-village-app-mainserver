# frozen_string_literal: true

class Messaging::Conversation < ApplicationRecord
  belongs_to :conversationable, polymorphic: true

  has_many :messages, class_name: "Messaging::Message", dependent: :destroy
  has_many :conversation_participants, class_name: "Messaging::ConversationParticipant", dependent: :destroy
  has_many :participants, through: :conversation_participants, source: :member

  def unread_messages_count(member)
    Messaging::Receipt
      .joins(:message)
      .where(messaging_messages: { conversation_id: id })
      .where(member: member, read: false)
      .count
  end
end

# == Schema Information
#
# Table name: messaging_conversations
#
#  id                    :bigint           not null, primary key
#  conversationable_type :string(255)      not null
#  conversationable_id   :bigint           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#