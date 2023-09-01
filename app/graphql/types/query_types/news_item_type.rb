# frozen_string_literal: true

module Types
  class QueryTypes::NewsItemType < Types::BaseObject
    field :id, ID, null: true
    field :visible, Boolean, null: true
    field :settings, QueryTypes::SettingType, null: true
    field :title, String, null: true
    field :external_id, String, null: true
    field :author, String, null: true
    field :full_version, Boolean, null: true
    field :characters_to_be_shown, String, null: true
    field :categories, [QueryTypes::CategoryType], null: true
    field :publication_date, String, null: true
    field :published_at, String, null: true
    field :show_publish_date, Boolean, null: true
    field :news_type, String, null: true
    field :data_provider, QueryTypes::DataProviderType, null: true
    field :address, QueryTypes::AddressType, null: true
    field :source_url, QueryTypes::WebUrlType, null: true
    field :content_blocks, [QueryTypes::ContentBlockType], null: true
    field :payload, GraphQL::Types::JSON, null: true
    field :updated_at, String, null: true
    field :created_at, String, null: true
    field :push_notifications_sent_at, String, null: true
  end
end
