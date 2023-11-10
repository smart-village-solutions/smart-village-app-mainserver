# frozen_string_literal: true

module Types
  class QueryTypes::PublicTransportation::RouteType < Types::BaseObject
    field :route_color, String, null: true
    field :route_desc, String, null: true
    field :route_long_name, String, null: true
    field :route_short_name, String, null: true
    field :route_text_color, String, null: true
    field :route_type, String, null: true
  end
end
