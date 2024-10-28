# frozen_string_literal: true

module Types
  class QueryTypes::GenericItemType < Types::BaseObject
    field :id, GraphQL::Types::ID, null: true
    field :accessibility_informations, [QueryTypes::AccessibilityInformationType], null: true
    field :addresses, [QueryTypes::AddressType], null: true
    field :author, String, null: true
    field :categories, [QueryTypes::CategoryType], null: true
    field :companies, [QueryTypes::OperatingCompanyType], null: true
    field :contacts, [QueryTypes::ContactType], null: true
    field :content_blocks, [QueryTypes::ContentBlockType], null: true
    field :data_provider, QueryTypes::DataProviderType, null: true
    field :dates, [QueryTypes::DateType], null: true
    field :discount_type, QueryTypes::DiscountType, null: true
    field :external_id, String, null: true
    field :generic_items, [QueryTypes::GenericItemType], null: true
    field :generic_type, String, null: true
    field :locations, [QueryTypes::LocationType], null: true
    field :media_contents, [QueryTypes::MediaContentType], null: true
    field :member_id, GraphQL::Types::ID, null: true
    field :generic_item_messages, [QueryTypes::GenericItemMessageType], null: true
    field :opening_hours, [QueryTypes::OpeningHourType], null: true
    field :payload, GraphQL::Types::JSON, null: true
    field :point_of_interest, QueryTypes::PointOfInterestType, null: true
    field :price_informations, [QueryTypes::PriceType], null: true
    field :publication_date, String, null: true
    field :published_at, String, null: true
    field :push_notifications, [QueryTypes::PushNotificationType], null: true
    field :quota, QueryTypes::QuotaType, null: true
    field :settings, QueryTypes::SettingType, null: true
    field :title, String, null: true
    field :teaser, String, null: true
    field :description, String, null: true
    field :visible, GraphQL::Types::Boolean, null: true
    field :web_urls, [QueryTypes::WebUrlType], null: true
    field :updated_at, String, null: true
    field :created_at, String, null: true
    field :ancestry, String, null: true

    def point_of_interest
      object.generic_itemable if object.generic_itemable_type == "PointOfInterest"
    end

    def categories
      object.categories.active
    end
  end
end
