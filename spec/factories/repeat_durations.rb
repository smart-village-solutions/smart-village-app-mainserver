FactoryBot.define do
  factory :repeat_duration do
    start_date { "2019-05-03" }
    end_date { "2019-05-03" }
    every_year { false }
  end
end
