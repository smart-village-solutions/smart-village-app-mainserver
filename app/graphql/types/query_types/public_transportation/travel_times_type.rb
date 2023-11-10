# frozen_string_literal: true

module Types
  class QueryTypes::PublicTransportation::TravelTimesType < Types::BaseObject
    field :arrival_time, String, null: true
    field :departure_time, String, null: true
    field :drop_off_type, String, null: true
    field :pickup_type, String, null: true
    field :route, QueryTypes::PublicTransportation::RouteType, null: true
    field :stop_headsign, String, null: true
    field :stop_sequence, String, null: true
    field :trip, QueryTypes::PublicTransportation::TripType, null: true
  end
end
