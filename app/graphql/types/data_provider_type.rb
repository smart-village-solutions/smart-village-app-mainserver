# frozen_string_literal: true

module Types
  class DataProviderType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: true
    field :logo, String, null: true
    field :description, String, null: true
    field :address, AddressType, null: true
    field :contact, ContactType, null: true
  end
end