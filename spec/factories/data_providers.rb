FactoryBot.define do
  factory :data_provider do
    name { "MyString" }
    logo { "MyString" }
    description { "MyString" }
  end
end

# == Schema Information
#
# Table name: data_providers
#
#  id               :bigint           not null, primary key
#  name             :string(255)
#  logo             :string(255)
#  description      :string(255)
#  provideable_type :string(255)
#  provideable_id   :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
