FactoryBot.define do
  factory :operating_company do
    name { "MyString" }
    trait :for_poi do
      association(:companyable, factory: :point_of_interest, active: true)
    end
  end
end

# == Schema Information
#
# Table name: operating_companies
#
#  id               :bigint           not null, primary key
#  name             :string(255)
#  companyable_type :string(255)
#  companyable_id   :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
