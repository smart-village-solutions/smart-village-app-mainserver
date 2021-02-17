# frozen_string_literal: true

module Types
  class QueryTypes::OperatingCompanyType < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: true
    field :address, QueryTypes::AddressType, null: true
    field :contact, QueryTypes::ContactType, null: true
  end
end
