# frozen_string_literal: true

module Types
  class QueryTypes::PublicJsonFileType < Types::BaseObject
    field :name, String, null: false
    field :content, GraphQL::Types::JSON, null: false
  end
end
