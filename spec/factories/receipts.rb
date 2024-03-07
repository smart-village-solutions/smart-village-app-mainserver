FactoryBot.define do
  factory :receipt do
    message { nil }
    member { nil }
    read { false }
    default { "" }
  end
end
