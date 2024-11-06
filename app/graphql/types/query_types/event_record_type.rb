# frozen_string_literal: true

module Types
  class QueryTypes::EventRecordType < Types::BaseObject
    field :id, GraphQL::Types::ID, null: true
    field :visible, GraphQL::Types::Boolean, null: true
    field :settings, QueryTypes::SettingType, null: true
    field :external_id, String, null: true
    field :parent_id, Integer, null: true
    field :description, String, null: true
    field :title, String, null: true
    field :dates, [QueryTypes::DateType], null: true
    field :date, QueryTypes::DateType, null: true
    field :list_date, String, null: true
    field :sort_date, String, null: true
    field :repeat, GraphQL::Types::Boolean, null: true
    field :repeat_duration, QueryTypes::RepeatDurationType, null: true
    field :category, QueryTypes::CategoryType, null: true
    field :categories, [QueryTypes::CategoryType], null: true
    field :addresses, [QueryTypes::AddressType], null: true
    field :location, QueryTypes::LocationType, null: true
    field :region_id, String, null: true
    field :region, QueryTypes::RegionType, null: true
    field :data_provider, QueryTypes::DataProviderType, null: true
    field :contacts, [QueryTypes::ContactType], null: true
    field :urls, [QueryTypes::WebUrlType], null: true
    field :media_contents, [QueryTypes::MediaContentType], null: true
    field :organizer, QueryTypes::OperatingCompanyType, null: true
    field :price_informations, [QueryTypes::PriceType], null: true
    field :accessibility_information, QueryTypes::AccessibilityInformationType, null: true
    field :tag_list, [String], null: true
    field :recurring, Boolean, null: true
    field :recurring_weekdays, [Integer], null: true
    field :recurring_type, Integer, null: true
    field :recurring_interval, Integer, null: true
    field :updated_at, String, null: true
    field :created_at, String, null: true
    field :announcements, [Types::QueryTypes::ShoutType], null: true

    def list_date
      object.try(:list_date) || object.try(:sort_date).try(:strftime, "%Y-%m-%d")
    end

    def announcements
      object.announcements.upcoming_announcements(context[:current_user])
    end

    def dates
      object.dates_upcoming
    end

    def categories
      object.active_categories
    end
  end
end
