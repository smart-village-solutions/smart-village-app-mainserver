# frozen_string_literal: true

module Types
  class LocationType < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: true
    field :department, String, null: true
    field :district, String, null: true
    field :region_name, String, null: true
    field :state, String, null: true
    field :geo_location, GeoLocationType, null: true
  end
end
