# frozen_string_literal: true

module Types
  class AccessibilityInformationInput < BaseInputObject
    argument :description, String, required: false
    argument :types, String, required: false
    argument :urls, [Types::WebUrlInput], required: false, as: :urls_attributes, prepare: ->(urls, ctx) { urls.map(&:to_h) }
  end
end