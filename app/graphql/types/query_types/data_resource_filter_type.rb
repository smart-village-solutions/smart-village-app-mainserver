# frozen_string_literal: true

module Types
  class QueryTypes::DataResourceFilterType < Types::BaseObject
    field :data_resource_type, String, null: false
    field :config, GraphQL::Types::JSON, null: true
  end
end
