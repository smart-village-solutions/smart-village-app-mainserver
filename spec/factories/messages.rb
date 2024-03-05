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
FactoryBot.define do
  factory :message do
    conversation { nil }
    member { nil }
    message_text { "MyText" }
  end
end
