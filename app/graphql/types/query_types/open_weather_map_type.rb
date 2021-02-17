# frozen_string_literal: true

module Types
  class QueryTypes::OpenWeatherMapType < Types::BaseObject
    field :id, ID, null: true
    field :lat, Float, null: true
    field :lon, Float, null: true
    field :current, GraphQL::Types::JSON, null: true
    field :hourly, [GraphQL::Types::JSON], null: true
    field :daily, [GraphQL::Types::JSON], null: true
    field :alerts, [GraphQL::Types::JSON], null: true
    field :updated_at, String, null: true
    field :created_at, String, null: true
  end
end
