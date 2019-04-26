# == Schema Information
#
# Table name: categories
#
#  id         :bigint(8)        not null, primary key
#  name       :string(255)
#  tmb_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :category do
    name { "MyString" }
    tmb_id { 1 }
  end
end
