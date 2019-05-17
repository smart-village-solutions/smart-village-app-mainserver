module Types
  class AddressInput < BaseInputObject
    argument :addition, String, required: false
    argument :street, String, required: false
    argument :zip, String, required: false
    argument :city, String, required: false
    argument :geo_location, Types::GeoLocationInput, required: false, as: :geo_location_attributes, prepare: ->(geo_location, ctx) { geo_location.to_h }
  end
end