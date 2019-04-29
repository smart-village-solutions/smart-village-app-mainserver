FactoryBot.define do
  factory :operating_company do
    name { "MyString" }
  end
end

# == Schema Information
#
# Table name: operating_companies
#
#  id               :bigint(8)        not null, primary key
#  name             :string(255)
#  companyable_type :string(255)
#  companyable_id   :bigint(8)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
