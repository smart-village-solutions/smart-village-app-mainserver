# frozen_string_literal: true

module Types
  class GeoLocationInput < BaseInputObject
    argument :latitude, AnyPrimitiveType, required: false
    argument :longitude, AnyPrimitiveType, required: false
  end
end
