# frozen_string_literal: true

module Types
  class GeoLocationInput < BaseInputObject
    argument :latitude, AnyPrimativeType, required: false
    argument :longitude, AnyPrimativeType, required: false
  end
end
