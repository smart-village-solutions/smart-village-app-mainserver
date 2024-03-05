FactoryBot.define do
  factory :message do
    conversation { nil }
    member { nil }
    message_text { "MyText" }
  end
end
