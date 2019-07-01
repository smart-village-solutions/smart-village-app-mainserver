# frozen_string_literal: true

module Types
  class PointOfInterestType < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: true
    field :description, String, null: true
    field :mobile_description, String, null: true
    field :addresses, [AddressType], null: true
    field :active, Boolean, null: true
    field :category, CategoryType, null: true
    field :location, LocationType, null: true
    field :data_provider, DataProviderType, null: true
    field :contact, ContactType, null: true
    field :web_urls, [WebUrlType], null: true
    field :media_contents, [MediaContentType], null: true
    field :operating_company, OperatingCompanyType, null: true
    field :opening_hours, [OpeningHourType], null: true
    field :price_informations, [PriceType], null: true
    field :certificates, [CertificateType], null: true
    field :accessibility_information, AccessibilityInformationType, null: true
    field :tag_list, [String], null: true
    field :updated_at, String, null: true
    field :created_at, String, null: true
  end
end
