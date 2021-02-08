FactoryBot.define do
  factory :lunch_offer do
    name { "MyString" }
    price { "MyString" }
  end
end

# == Schema Information
#
# Table name: lunch_offers
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  price      :string(255)
#  lunch_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
