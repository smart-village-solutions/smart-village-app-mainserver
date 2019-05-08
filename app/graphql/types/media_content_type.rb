module Types
  class MediaContentType < Types::BaseObject
    field :id, ID, null: false
    field :caption_text, String, null: false
    field :copyright, String, null: true
    field :height, String, null: true
    field :width, Boolean, null: true
    field :content_type, [AdressType], null: false
    field :source_url, WebUrlType, null: false
  end
end