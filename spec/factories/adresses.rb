FactoryBot.define do
  factory :adress do
    addition { "MyString" }
    city { "MyString" }
    street { "MyString" }
    zip { "MyString" }
    geo_location { nil }
  end
end
