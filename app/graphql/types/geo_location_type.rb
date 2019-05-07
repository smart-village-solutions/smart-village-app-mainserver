# frozen_string_literal: true

module Types
  class GeoLocationType < Types::BaseObject
    field :id, ID, null: false
    field :latitude, Float, null: false
    field :longitude, Float, null: false
  end
end
