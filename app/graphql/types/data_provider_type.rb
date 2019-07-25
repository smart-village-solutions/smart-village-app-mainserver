# frozen_string_literal: true

module Types
  class DataProviderType < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: true
    field :logo, WebUrlType, null: true
    field :description, String, null: true
    field :address, AddressType, null: true
    field :contact, ContactType, null: true
  end
end
