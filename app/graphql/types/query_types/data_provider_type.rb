# frozen_string_literal: true

module Types
  class QueryTypes::DataProviderType < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: true
    field :data_type, String, null: true
    field :logo, QueryTypes::WebUrlType, null: true
    field :description, String, null: true
    field :address, QueryTypes::AddressType, null: true
    field :contact, QueryTypes::ContactType, null: true
    field :notice, String, null: true
  end
end
