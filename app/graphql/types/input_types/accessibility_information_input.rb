# frozen_string_literal: true

module Types
  class InputTypes::AccessibilityInformationInput < BaseInputObject
    argument :description, String, required: false
    argument :types, String, required: false
    argument :urls, [Types::InputTypes::WebUrlInput], required: false,
                                          as: :urls_attributes,
                                          prepare: ->(urls, _ctx) { urls.map(&:to_h) }
  end
end
