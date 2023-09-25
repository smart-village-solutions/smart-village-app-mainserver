# frozen_string_literal: true

module Types
  class QueryTypes::PublicTransportation::TripType < Types::BaseObject
    field :bikes_allowed, String, null: true
    field :direction_id, String, null: true
    field :trip_headsign, String, null: true
    field :trip_short_name, String, null: true
    field :wheelchair_accessible, String, null: true
  end
end
