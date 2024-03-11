# frozen_string_literal: true

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
require 'rails_helper'

RSpec.describe Messaging::Conversation, type: :model do
  it { is_expected.to belong_to(:conversationable) }
  it { is_expected.to have_many(:messages).class_name("Messaging::Message") }
  it { is_expected.to have_many(:conversation_participants).class_name("Messaging::ConversationParticipant") }
  it { is_expected.to have_many(:members).through(:conversation_participants).class_name("Member") }
end
