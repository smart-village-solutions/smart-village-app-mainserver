# frozen_string_literal: true

class SmartVillageAppMainserverSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  # graphql-remote_loader is dependant on GraphQL::Batch, so you need to include it here.
  # To learn more about GraphQL::Batch, see https://github.com/Shopify/graphql-batch
  use GraphQL::Batch
end
