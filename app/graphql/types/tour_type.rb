# frozen_string_literal: true

module Types
  class TourType < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: true
    field :description, String, null: true
    field :mobile_description, String, null: true
    field :active, Boolean, null: true
    field :addresses, [AddressType], null: true
    field :means_of_transportation, String, null: true
    field :length_km, Integer, null: true
    field :category, CategoryType, null: true
    field :data_provider, DataProviderType, null: true
    field :tags, String, null: true
    field :contact, ContactType, null: true
    field :web_urls, [WebUrlType], null: true
    field :media_contents, [MediaContentType], null: true
    field :operating_company, OperatingCompanyType, null: true
    field :certificates, [CertificateType], null: true
    field :regions, [RegionType], null: true
    field :geometry_tour_data, [GeoLocationType], null: false
    field :updated_at, String, null: true
    field :created_at, String, null: true
  end
end
