FactoryBot.define do
  factory :member do
    keycloak_id { "MyString" }
  end
end

# == Schema Information
#
# Table name: members
#
#  id              :bigint           not null, primary key
#  keycloak_id     :string(255)
#  municipality_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
