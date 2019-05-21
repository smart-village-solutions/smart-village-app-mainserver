# frozen_string_literal: true

module Types
  class LocationInput < BaseInputObject
    argument :name, String, required: false
    argument :department, String, required: false
    argument :district, String, required: false
    argument :region_id, Integer, required: false
    argument :state, String, required: false
    argument :geo_location, Types::GeoLocationInput, required: false,
                                                     as: :geo_location_attributes,
                                                     prepare: lambda { |geo_location, _ctx|
                                                                geo_location.to_h
                                                              }
  end
end
