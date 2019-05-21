# frozen_string_literal: true

module Types
  class DataProviderInput < BaseInputObject
    argument :name, String, required: false
    argument :address, Types::AddressInput, required: false, as: :address_attributes, prepare: ->(address, ctx) { address.to_h }
    argument :contact, Types::ContactInput, required: false, as: :contact_attributes, prepare: ->(contact, _ctx) { contact.to_h }
    argument :logo, Types::WebUrlInput, required: false, as: :logo_attributes, prepare: ->(logo, _ctx) { logo.to_h }
    argument :description, String, required: false
  end
end