# frozen_string_literal: true

module Types
  class QueryTypes::TourStopType < Types::BaseObject
    field :id, ID, null: true
    field :visible, Boolean, null: true
    field :settings, QueryTypes::SettingType, null: true
    field :external_id, String, null: true
    field :name, String, null: true
    field :description, String, null: true
    field :mobile_description, String, null: true
    field :addresses, [QueryTypes::AddressType], null: true
    field :active, Boolean, null: true
    field :category, QueryTypes::CategoryType, null: true
    field :categories, [QueryTypes::CategoryType], null: true
    field :location, QueryTypes::LocationType, null: true
    field :data_provider, QueryTypes::DataProviderType, null: true
    field :contact, QueryTypes::ContactType, null: true
    field :web_urls, [QueryTypes::WebUrlType], null: true
    field :media_contents, [QueryTypes::MediaContentType], null: true
    field :operating_company, QueryTypes::OperatingCompanyType, null: true
    field :certificates, [QueryTypes::CertificateType], null: true
    field :accessibility_information, QueryTypes::AccessibilityInformationType, null: true
    field :tag_list, [String], null: true
    field :payload, GraphQL::Types::JSON, null: true
    field :updated_at, String, null: true
    field :created_at, String, null: true
  end
end
