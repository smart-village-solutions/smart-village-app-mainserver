# frozen_string_literal: true

module Types
  class QueryTypes::ReportType < Types::BaseObject
    field :id, GraphQL::Types::ID, null: true
  end
end
