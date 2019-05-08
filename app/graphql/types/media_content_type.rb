module Types
  class MediaContentType < Types::BaseObject
    field :id, ID, null: false
    field :caption_text, String, null: false
    field :copyright, String, null: true
    field :height, Integer, null: true
    field :width, Integer, null: true
    field :content_type, String, null: false
    field :source_url, WebUrlType, null: false
  end
end