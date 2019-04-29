FactoryBot.define do
  factory :point_of_interest do
    external_id { 1 }
    name { "MyString" }
    description { "MyString" }
    mobile_description { "MyString" }
    active { false }
    thumbnail_url { "MyString" }
  end
end

# == Schema Information
#
# Table name: point_of_interests
#
#  id                 :bigint(8)        not null, primary key
#  external_id        :integer
#  name               :string(255)
#  description        :string(255)
#  mobile_description :string(255)
#  active             :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
