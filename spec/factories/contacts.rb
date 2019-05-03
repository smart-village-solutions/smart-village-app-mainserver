# frozen_string_literal: true

FactoryBot.define do
  factory :contact do
    phone { "01234567" }
    fax { "MyString" }
    email { "my.string@test.de" }
    trait :for_operating_company do
      association(:contactable, factory: %i[operating_company for_poi])
    end
  end
end

# == Schema Information
#
# Table name: contacts
#
#  id               :bigint           not null, primary key
#  first_name       :string(255)
#  last_name        :string(255)
#  phone            :string(255)
#  fax              :string(255)
#  email            :string(255)
#  contactable_type :string(255)
#  contactable_id   :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
