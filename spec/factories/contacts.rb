FactoryBot.define do
  factory :contact do
    phone { "01234567" }
    fax { "MyString" }
    email { "my.string@test.de" }
    trait :for_operating_company do
      association(:contactable, factory: [:operating_company, :for_poi])
    end
  end
end

# == Schema Information
#
# Table name: contacts
#
#  id               :bigint(8)        not null, primary key
#  first_name       :string(255)
#  last_name        :string(255)
#  phone            :string(255)
#  fax              :string(255)
#  email            :string(255)
#  contactable_type :string(255)
#  contactable_id   :bigint(8)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
