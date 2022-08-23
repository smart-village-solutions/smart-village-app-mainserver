# frozen_string_literal: true

module Types
  class QueryTypes::RepeatDurationType < Types::BaseObject
    field :id, GraphQL::Types::ID, null: true
    field :start_date, String, null: true
    field :end_date, String, null: true
    field :every_year, GraphQL::Types::Boolean, null: true
  end
end
