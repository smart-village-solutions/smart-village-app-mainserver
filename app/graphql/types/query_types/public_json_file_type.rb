# frozen_string_literal: true

module Types
  class QueryTypes::PublicJsonFileType < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: false
    field :content, GraphQL::Types::JSON, null: false
    field :data_type, String, null: true
    field :version, String, null: true
    field :updated_at, String, null: true
    field :created_at, String, null: true
  end
end
