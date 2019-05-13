# frozen_string_literal: true

module Types
  class EventRecordType < Types::BaseObject
    field :id, ID, null: false
    field :parent_id, String, null: true
    field :description, String, null: true
    field :title, String, null: false
    field :dates, [DateType], null: false
    field :repeat, Boolean, null: true
    field :repeat_duration, RepeatDurationType, null: true
    field :category_id, Integer, null: false
    field :addresses, [AddressType], null: false
    field :location, LocationType, null: true
    field :data_provider, DataProviderType, null: true
    field :contacts, [ContactType], null: true
    field :urls, [WebUrlType], null: true
    field :media_contents, [MediaContentType], null: true
    field :organizer, OperatingCompanyType, null: true
    field :price_informations, [PriceType], null: true
    field :accessibilty_information, AccessibiltyInformationType, null: true
    field :updated_at, String, null: true
    field :created_at, String, null: true
  end
end
