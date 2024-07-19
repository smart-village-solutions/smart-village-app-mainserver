# frozen_string_literal: true

module Types
  class QueryTypes::PointOfInterestType < Types::BaseObject
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
    field :opening_hours, [QueryTypes::OpeningHourType], null: true
    field :price_informations, [QueryTypes::PriceType], null: true
    field :certificates, [QueryTypes::CertificateType], null: true
    field :accessibility_information, QueryTypes::AccessibilityInformationType, null: true
    field :tag_list, [String], null: true
    field :travel_times, [QueryTypes::PublicTransportation::TravelTimesType], null: true do
      argument :date, String, required: false
      argument :sort_by, String, required: false
      argument :sort_order, String, required: false
    end
    field :has_travel_times, Boolean, null: true
    field :lunches, [QueryTypes::LunchType], null: true
    field :payload, GraphQL::Types::JSON, null: true
    field :vouchers, [QueryTypes::GenericItemType], null: true
    field :updated_at, String, null: true
    field :created_at, String, null: true

    def travel_times(date: "", sort_by: "arrival_time", sort_order: "asc")
      return [] if date.blank?

      object.gtfs_travel_times(date: date, sort_by: sort_by, sort_order: sort_order)
    end

    def has_travel_times
      object.has_travel_times?
    end

    def vouchers
      [] # there is no vouchers feature for int/development
    end
  end
end
