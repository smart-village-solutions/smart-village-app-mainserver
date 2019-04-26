# == Schema Information
#
# Table name: data_providers
#
#  id               :bigint(8)        not null, primary key
#  name             :string(255)
#  logo             :string(255)
#  description      :string(255)
#  provideable_type :string(255)
#  provideable_id   :bigint(8)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryBot.define do
  factory :data_provider do
    name { "MyString" }
    logo { "MyString" }
    description { "MyString" }
  end
end
