# frozen_string_literal: true

module Types
  class InputTypes::AddressInput < BaseInputObject
    argument :id, Integer, required: false
    argument :addition, String, required: false
    argument :street, String, required: false
    argument :zip, String, required: false
    argument :city, String, required: false
    argument :kind, String, required: false
    argument :geo_location, Types::InputTypes::GeoLocationInput, required: false,
                                                     as: :geo_location_attributes,
                                                     prepare: lambda { |geo_location, _ctx|
                                                                geo_location.to_h
                                                              }
  end
end
