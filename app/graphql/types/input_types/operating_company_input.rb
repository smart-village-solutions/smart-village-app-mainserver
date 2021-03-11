# frozen_string_literal: true

module Types
  class InputTypes::OperatingCompanyInput < BaseInputObject
    argument :name, String, required: false
    argument :address, Types::InputTypes::AddressInput, required: false,
                                            as: :address_attributes,
                                            prepare: ->(address, _ctx) { address.to_h }
    argument :contact, Types::InputTypes::ContactInput, required: false,
                                            as: :contact_attributes,
                                            prepare: ->(contact, _ctx) { contact.to_h }
  end
end
