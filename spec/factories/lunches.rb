FactoryBot.define do
  factory :lunch do
    text { "MyText" }
    point_of_interest_id { 1 }
    point_of_interest_attributes { "MyString" }

    factory :lunch_with_dates do
      transient do
        dates_count { 5 }
      end

      after(:create) do |lunch, evaluator|
        create_list(:lunch, evaluator.dates_count, lunch: lunch)
      end
    end
  end
end

# == Schema Information
#
# Table name: lunches
#
#  id                           :bigint           not null, primary key
#  text                         :text(65535)
#  point_of_interest_id         :integer
#  point_of_interest_attributes :string(255)
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
