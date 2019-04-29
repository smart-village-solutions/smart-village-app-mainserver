FactoryBot.define do
  factory :accessibilty_information do
    description { "MyString" }
    types { "MyString" }
    web_url { nil }
  end
end

# == Schema Information
#
# Table name: accessibilty_informations
#
#  id              :bigint(8)        not null, primary key
#  description     :string(255)
#  types           :string(255)
#  accessable_type :string(255)
#  accessable_id   :bigint(8)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
