# frozen_string_literal: true

# == Schema Information
#
# Table name: conversation_participants
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
  it { is_expected.to belong_to(:conversation) }
  it { is_expected.to belong_to(:member) }
end
