# == Schema Information
#
# Table name: adresses
#
#  id              :bigint(8)        not null, primary key
#  addition        :string(255)
#  city            :string(255)
#  street          :string(255)
#  zip             :string(255)
#  adressable_type :string(255)
#  adressable_id   :bigint(8)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryBot.define do
  factory :adress do
    addition { "MyString" }
    city { "MyString" }
    street { "MyString" }
    zip { "MyString" }
    geo_location { nil }
  end
end
