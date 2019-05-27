# frozen_string_literal: true

module Types
  class NewsItemType < Types::BaseObject
    field :id, ID, null: false
    field :author, String, null: true
    field :full_version, Boolean, null: true
    field :characters_to_be_shown, String, null: true
    field :publication_date, String, null: true
    field :published_at, String, null: false
    field :show_publish_date, Boolean, null: false
    field :news_type, String, null: true
    field :data_provider, DataProviderType, null: true
    field :address, AddressType, null: true
    field :source_url, WebUrlType, null: true
    field :content_blocks, [ContentBlockType], null: true
    field :updated_at, String, null: true
    field :created_at, String, null: true
  end
end
