# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Messaging::Conversation, type: :model do
  it { is_expected.to belong_to(:conversationable) }
  it { is_expected.to have_many(:conversation_participants) }
  it { is_expected.to have_many(:members).through(:conversation_participants) }
end
