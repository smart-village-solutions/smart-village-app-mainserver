# frozen_string_literal: true

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
require 'rails_helper'

RSpec.describe Messaging::ConversationParticipant, type: :model do
  it { is_expected.to belong_to(:conversation).class_name("Messaging::Conversation") }
  it { is_expected.to belong_to(:member).class_name("Member") }
end