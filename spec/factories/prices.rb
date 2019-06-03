FactoryBot.define do
  factory :price do
    name { "MyString" }
    price { 1 }
    group_price { false }
    age_from { 1 }
    age_to { 1 }
    min_adult_count { 1 }
    max_adult_count { 1 }
    min_children_count { 1 }
    max_children_count { 1 }
    description { "MyString" }
  end
end

# == Schema Information
#
# Table name: prices
#
#  id                 :bigint           not null, primary key
#  name               :string(255)
#  amount             :float(24)
#  group_price        :boolean
#  age_from           :integer
#  age_to             :integer
#  min_adult_count    :integer
#  max_adult_count    :integer
#  min_children_count :integer
#  max_children_count :integer
#  description        :text(65535)
#  category           :string(255)
#  priceable_type     :string(255)
#  priceable_id       :bigint
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
