# frozen_string_literal: true

module Types
  class QueryTypes::GenericItemType < Types::BaseObject
    field :id, ID, null: true
    field :visible, Boolean, null: true
    field :settings, QueryTypes::SettingType, null: true
    field :title, String, null: true
    field :generic_type, String, null: true
    field :external_id, String, null: true
    field :author, String, null: true
    field :categories, [QueryTypes::CategoryType], null: true
    field :companies, [QueryTypes::OperatingCompanyType], null: true
    field :publication_date, String, null: true
    field :published_at, String, null: true
    field :data_provider, QueryTypes::DataProviderType, null: true
    field :addresses, [QueryTypes::AddressType], null: true
    field :web_urls, [QueryTypes::WebUrlType], null: true
    field :content_blocks, [QueryTypes::ContentBlockType], null: true
    field :generic_items, [QueryTypes::GenericItemType], null: true
    field :updated_at, String, null: true
    field :created_at, String, null: true
  end
end
