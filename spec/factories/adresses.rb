FactoryBot.define do
  factory :adress do
    addition { "MyString" }
    city { "MyString" }
    street { "MyString" }
    zip { "MyString" }
    geo_location { nil }
  end
end

# == Schema Information
#
# Table name: adresses
#
#  id              :bigint           not null, primary key
#  addition        :string(255)
#  city            :string(255)
#  street          :string(255)
#  zip             :string(255)
#  adressable_type :string(255)
#  adressable_id   :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
