# frozen_string_literal: true

module Types
  class EventRecordType < Types::BaseObject
    field :id, ID, null: false
    field :parent_id, Integer, null: true
    field :description, String, null: true
    field :title, String, null: true
    field :dates, [DateType], null: true
    field :repeat, Boolean, null: true
    field :repeat_duration, RepeatDurationType, null: true
    field :category_id, Integer, null: true
    field :addresses, [AddressType], null: true
    field :location, LocationType, null: true
    field :region_id, String, null: true
    field :data_provider, DataProviderType, null: true
    field :contacts, [ContactType], null: true
    field :urls, [WebUrlType], null: true
    field :media_contents, [MediaContentType], null: true
    field :organizer, OperatingCompanyType, null: true
    field :price_informations, [PriceType], null: true
    field :accessibility_information, AccessibilityInformationType, null: true
    field :tag_list, [String], null: true
    field :updated_at, String, null: true
    field :created_at, String, null: true
  end
end
