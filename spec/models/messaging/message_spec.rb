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
require 'rails_helper'

RSpec.describe Messaging::Message, type: :model do
  it { is_expected.to belong_to(:conversation).class_name("Messaging::Conversation") }
  it { is_expected.to belong_to(:member) }
end
