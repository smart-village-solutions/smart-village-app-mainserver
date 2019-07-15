# frozen_string_literal: true

module Types
  class AddressType < Types::BaseObject
    field :id, ID, null: true
    field :addition, String, null: true
    field :street, String, null: true
    field :city, String, null: true
    field :zip, String, null: true
    field :kind, String, null: true
    field :geo_location, GeoLocationType, null: true
  end
end
