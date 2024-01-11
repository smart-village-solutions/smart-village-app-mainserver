# frozen_string_literal: true

FactoryBot.define do
  factory :quota do
    max_quantity { 100 }
    frequency { "once" }
    max_per_person { 2 }
  end
end
