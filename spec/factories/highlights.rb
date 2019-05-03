FactoryBot.define do
  factory :highlight do
    event { false }
    holiday { false }
    local { false }
    monthly { false }
    regional { false }
    highlightable { nil }
  end
end
