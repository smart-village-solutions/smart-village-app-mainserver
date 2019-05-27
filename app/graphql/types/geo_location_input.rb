# frozen_string_literal: true

module Types
  class GeoLocationInput < BaseInputObject
    argument :latitude, Float, required: false
    argument :longitude, Float, required: false
  end
end
