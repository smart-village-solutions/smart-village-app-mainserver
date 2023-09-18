# frozen_string_literal: true

module Types
  class QueryTypes::TourType < Types::BaseObject
    field :id, ID, null: true
    field :visible, Boolean, null: true
    field :settings, QueryTypes::SettingType, null: true
    field :external_id, String, null: true
    field :name, String, null: true
    field :description, String, null: true
    field :mobile_description, String, null: true
    field :addresses, [QueryTypes::AddressType], null: true
    field :active, Boolean, null: true
    field :means_of_transportation, String, null: true
    field :length_km, Integer, null: true
    field :category, QueryTypes::CategoryType, null: true
    field :categories, [QueryTypes::CategoryType], null: true
    field :location, QueryTypes::LocationType, null: true
    field :data_provider, QueryTypes::DataProviderType, null: true
    field :contact, QueryTypes::ContactType, null: true
    field :web_urls, [QueryTypes::WebUrlType], null: true
    field :media_contents, [QueryTypes::MediaContentType], null: true
    field :operating_company, QueryTypes::OperatingCompanyType, null: true
    field :certificates, [QueryTypes::CertificateType], null: true
    field :tag_list, [String], null: true
    field :regions, [QueryTypes::RegionType], null: true
    field :geometry_tour_data, [QueryTypes::GeoLocationType], null: false
    field :payload, GraphQL::Types::JSON, null: true
    field :tour_stops, [QueryTypes::TourStopType], null: true
    field :updated_at, String, null: true
    field :created_at, String, null: true
  end
end
