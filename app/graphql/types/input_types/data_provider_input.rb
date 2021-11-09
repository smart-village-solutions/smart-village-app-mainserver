# frozen_string_literal: true

module Types
  class InputTypes::DataProviderInput < BaseInputObject
    argument :name, String, required: true
    argument :data_type, String, required: false
    argument :address, Types::InputTypes::AddressInput, required: false,
                                            as: :address_attributes,
                                            prepare: ->(address, _ctx) { address.to_h }
    argument :contact, Types::InputTypes::ContactInput, required: false,
                                            as: :contact_attributes,
                                            prepare: ->(contact, _ctx) { contact.to_h }
    argument :logo, Types::InputTypes::WebUrlInput, required: false,
                                        as: :logo_attributes,
                                        prepare: ->(logo, _ctx) { logo.to_h }
    argument :description, String, required: false
    argument :notice, String, required: false
  end
end
