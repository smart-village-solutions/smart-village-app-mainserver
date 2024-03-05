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
  factory :conversation_participant do
    conversation { nil }
    member { nil }
    email_notification_enabled { false }
    push_notification_enabled { false }
  end
end
