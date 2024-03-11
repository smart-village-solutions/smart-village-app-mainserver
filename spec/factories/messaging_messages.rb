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
FactoryBot.define do
  factory :messaging_message, class: "Messaging::Message" do
    association :conversation, factory: :messaging_conversation
    association :sender, factory: :member
    message_text { Faker::Lorem.sentence }
  end
end
