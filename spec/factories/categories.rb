FactoryBot.define do
  factory :category do
    name { "MyString" }
    tmb_id { 1 }
  end
end

# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  tmb_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ancestry   :string(255)
#
