# frozen_string_literal: true

class Messaging::ConversationParticipant < ApplicationRecord
  belongs_to :conversation, class_name: "Messaging::Conversation"
  belongs_to :member, class_name: "Member"

  validates :member_id, uniqueness: { scope: :conversation_id }
end

# == Schema Information
#
# Table name: messaging_conversation_participants
#
#  id                         :bigint           not null, primary key
#  conversation_id            :bigint           not null
#  member_id                  :bigint           not null
#  email_notification_enabled :boolean          default(TRUE)
#  push_notification_enabled  :boolean          default(TRUE)
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#