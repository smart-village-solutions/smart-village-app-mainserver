FactoryBot.define do
  factory :member do
    keycloak_id { "MyString" }
  end
end

# == Schema Information
#
# Table name: members
#
#  id                              :bigint           not null, primary key
#  keycloak_id                     :string(255)
#  municipality_id                 :integer
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  email                           :string(255)      default(""), not null
#  encrypted_password              :string(255)      default(""), not null
#  authentication_token            :text(65535)
#  authentication_token_created_at :datetime
#
