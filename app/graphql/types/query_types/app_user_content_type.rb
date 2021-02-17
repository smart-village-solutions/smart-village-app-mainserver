# frozen_string_literal: true

module Types
  class QueryTypes::AppUserContentType < Types::BaseObject
    field :id, ID, null: true
    field :data_source, String, null: true
    field :data_type, String, null: true
    field :content, String, null: true
    field :updated_at, String, null: true
    field :created_at, String, null: true
  end
end
