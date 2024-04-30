# == Schema Information
#
# Table name: external_service_credentials
#
#  id                  :bigint           not null, primary key
#  client_key          :text(65535)
#  client_secret       :text(65535)
#  scopes              :string(255)
#  auth_type           :string(255)
#  external_id         :text(65535)
#  external_service_id :bigint           not null
#  data_provider_id    :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  additional_params   :text(65535)
#
FactoryBot.define do
  factory :external_service_credential do
    client_key { "MyString" }
    client_secret { "MyString" }
    scopes { "MyString" }
    auth_type { "MyString" }
    external_id { "MyString" }
    external_service { nil }
    data_provider { nil }
  end
end
