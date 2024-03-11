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
FactoryBot.define do
  factory :messaging_conversation, class: "Messaging::Conversation" do
    association :conversationable, factory: :generic_item
  end
end
