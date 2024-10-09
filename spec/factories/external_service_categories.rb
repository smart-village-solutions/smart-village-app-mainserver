FactoryBot.define do
  factory :external_service_category do
    external_id { "MyString" }
    external_service { nil }
  end
end

# == Schema Information
#
# Table name: external_service_categories
#
#  id                  :bigint           not null, primary key
#  external_id         :string(255)
#  external_service_id :bigint           not null
#  category_id         :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
