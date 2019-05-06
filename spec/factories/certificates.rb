FactoryBot.define do
  factory :certificate do
    name { "MyString" }
  end
end

# == Schema Information
#
# Table name: certificates
#
#  id                   :bigint           not null, primary key
#  name                 :string(255)
#  attraction_id :bigint
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
