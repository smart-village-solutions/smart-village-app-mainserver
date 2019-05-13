FactoryBot.define do
  factory :address do
    addition { "MyString" }
    city { "MyString" }
    street { "MyString" }
    zip { "MyString" }
    geo_location { nil }
  end
end

# == Schema Information
#
# Table name: addresses
#
#  id              :bigint           not null, primary key
#  addition        :string(255)
#  city            :string(255)
#  street          :string(255)
#  zip             :string(255)
#  kind            :integer          default("default")
#  addressable_type :string(255)
#  addressable_id   :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
