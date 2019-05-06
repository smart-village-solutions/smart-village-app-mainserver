FactoryBot.define do
  factory :fixed_date do
    date_start { "2019-05-06" }
    date_end { "2019-05-06" }
    weekday { "MyString" }
    time_start { "2019-05-06 12:17:44" }
    time_end { "2019-05-06 12:17:44" }
    time_Description { "MyString" }
    use_only_time_description { false }
    dateable { nil }
  end
end
