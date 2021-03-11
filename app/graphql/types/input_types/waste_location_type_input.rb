# frozen_string_literal: true

module Types
  class InputTypes::WasteLocationTypeInput < BaseInputObject
    argument :waste_type, String, required: false
    argument :address_id, Integer, required: false
    argument :address, Types::InputTypes::AddressInput, required: false,
                                            as: :address_attributes,
                                            prepare: lambda { |address, _ctx|
                                                       address.to_h
                                                     }

  end
end
