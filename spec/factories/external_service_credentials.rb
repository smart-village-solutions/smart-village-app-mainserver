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
