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
#  id          :bigint           not null, primary key
#  name        :string(255)
#  description :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
