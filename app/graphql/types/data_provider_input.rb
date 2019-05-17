# frozen_string_literal: true

module Types
  class DataProviderInput < BaseInputObject
    argument :name, String, required: true
    argument :logo, String, required: true
    argument :description, String, required: true
    argument :address, Types::AddressInput, required: false, as: :address_attributes, prepare: ->(address, ctx) { address.to_h }
    argument :contact, ContactType, required: true
  end
end
