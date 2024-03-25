# == Schema Information
#
# Table name: external_services
#
#  id              :bigint           not null, primary key
#  name            :string(255)
#  base_uri        :string(255)
#  resource_config :text(65535)
#  municipality_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
FactoryBot.define do
  factory :external_service do
    name { "MyString" }
    base_uri { "MyString" }
    resource_config { "" }
  end
end
