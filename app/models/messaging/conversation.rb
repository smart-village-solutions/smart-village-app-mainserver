# frozen_string_literal: true

class Messaging::Conversation < ApplicationRecord
  belongs_to :conversationable, polymorphic: true
  belongs_to :owner, class_name: "Member", foreign_key: "owner_id"

  has_many :messages, class_name: "Messaging::Message", dependent: :destroy
  has_many :conversation_participants, class_name: "Messaging::ConversationParticipant", dependent: :destroy
  has_many :members, through: :conversation_participants, class_name: "Member"
end

# == Schema Information
#
# Table name: conversations
#
#  id                    :bigint           not null, primary key
#  conversationable_type :string(255)      not null
#  conversationable_id   :bigint           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
