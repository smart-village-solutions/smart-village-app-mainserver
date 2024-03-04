FactoryBot.define do
  factory :conversation_participant do
    conversation { nil }
    member { nil }
    email_notification_enabled { false }
    push_notification_enabled { false }
  end
end
