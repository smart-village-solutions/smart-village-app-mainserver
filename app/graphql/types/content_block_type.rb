# frozen_string_literal: true

module Types
  class NewsItemType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: true
    field :intro, String, null: true
    field :body, String, null: true
    field :media_contents, [MediaContentType], null: true
    field :updated_at, String, null: true
    field :created_at, String, null: true
  end
end