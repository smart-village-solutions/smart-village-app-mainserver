# frozen_string_literal: true

module Types
  class QueryTypes::GeoLocationType < Types::BaseObject
    field :id, ID, null: true
    field :latitude, Float, null: true
    field :longitude, Float, null: true
  end
end
