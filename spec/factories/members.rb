FactoryBot.define do
  factory :member do
    keycloak_id { Faker::Internet.uuid }
    municipality
    email { Faker::Internet.email }
    password { "MyP@ssw0rd!" }
  end
end
# == Schema Information
#
# Table name: members
#
#  id                                :bigint           not null, primary key
#  keycloak_id                       :string(255)
#  municipality_id                   :integer
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  email                             :string(255)      default(""), not null
#  encrypted_password                :string(255)      default(""), not null
#  authentication_token              :text(65535)
#  authentication_token_created_at   :datetime
#  keycloak_access_token             :text(65535)
#  keycloak_access_token_expires_at  :datetime
#  keycloak_refresh_token            :text(65535)
#  keycloak_refresh_token_expires_at :datetime
#  preferences                       :text(65535)
#  reset_password_token              :string(255)
#  reset_password_sent_at            :datetime
#  unlock_token                      :string(255)
#
