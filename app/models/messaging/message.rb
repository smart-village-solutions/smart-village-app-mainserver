# frozen_string_literal: true

class Messaging::Message < ApplicationRecord
  belongs_to :conversation, class_name: "Messaging::Conversation"
  belongs_to :sender, class_name: "Member", foreign_key: "sender_id"

  has_many :receipts, class_name: "Messaging::Receipt", dependent: :destroy
  has_many :members, through: :receipts
end

# == Schema Information
#
# Table name: messaging_messages
#
#  id              :bigint           not null, primary key
#  conversation_id :bigint           not null
#  message_text    :text(65535)
#  sender_id       :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#