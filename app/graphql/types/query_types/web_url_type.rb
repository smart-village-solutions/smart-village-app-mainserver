# frozen_string_literal: true

module Types
  class QueryTypes::WebUrlType < Types::BaseObject
    field :id, GraphQL::Types::ID, null: true
    field :url, String, null: true
    field :description, String, null: true
  end
end
