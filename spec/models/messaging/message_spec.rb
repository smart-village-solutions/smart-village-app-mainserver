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
require 'rails_helper'

RSpec.describe Messaging::Message, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
