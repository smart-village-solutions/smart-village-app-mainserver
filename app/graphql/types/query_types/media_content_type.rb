# frozen_string_literal: true

module Types
  class QueryTypes::MediaContentType < Types::BaseObject
    field :id, ID, null: true
    field :caption_text, String, null: true
    field :copyright, String, null: true
    field :height, Integer, null: true
    field :width, Integer, null: true
    field :content_type, String, null: true
    field :source_url, QueryTypes::WebUrlType, null: true
  end
end
