# frozen_string_literal: true

module Types
  class OperatingCompanyInput < BaseInputObject
    argument :name, String, required: true
    argument :address, Types::AddressInput, required: false, as: :address_attributes, prepare: ->(address, ctx) { address.to_h }
    argument :contact, Types::ContactInput, required: false, as: :contact_attributes, prepare: ->(contact, ctx) { contact.to_h}
  end
end
