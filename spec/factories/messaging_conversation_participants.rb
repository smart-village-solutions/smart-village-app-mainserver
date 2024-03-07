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
FactoryBot.define do
  factory :messaging_conversation_participant, class: "Messaging::ConversationParticipant" do
    association :conversation, factory: :messaging_conversation
    member
    email_notification_enabled { true }
    push_notification_enabled { true }
  end
end
