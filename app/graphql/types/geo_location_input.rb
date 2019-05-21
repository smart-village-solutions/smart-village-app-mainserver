# frozen_string_literal: true

module Types
  class GeoLocationInput < BaseInputObject
    argument :latitude, Float, required: true
    argument :longitude, Float, required: true
  end
end
