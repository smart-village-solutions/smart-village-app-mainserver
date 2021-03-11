# frozen_string_literal: true

module Types
  class QueryTypes::ContentBlockType < Types::BaseObject
    field :id, ID, null: true
    field :title, String, null: true
    field :intro, String, null: true
    field :body, String, null: true
    field :media_contents, [QueryTypes::MediaContentType], null: true
    field :updated_at, String, null: true
    field :created_at, String, null: true
  end
end
