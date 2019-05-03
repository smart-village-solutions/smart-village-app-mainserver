FactoryBot.define do
  factory :repeat_duration do
    start { "2019-05-03" }
    end { "2019-05-03" }
    every_year { false }
  end
end
