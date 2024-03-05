# frozen_string_literal: true

class Messaging::Message < ApplicationRecord
  belongs_to :conversation, class_name: "Messaging::Conversation"
  belongs_to :sender, class_name: "Member", foreign_key: "sender_id"
end

# == Schema Information
#
# Table name: messages
#
#  id              :bigint           not null, primary key
#  conversation_id :bigint           not null
#  member_id       :bigint           not null
#  message_text    :text(65535)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
