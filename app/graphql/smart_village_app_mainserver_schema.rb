# frozen_string_literal: true

class SmartVillageAppMainserverSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)
end
