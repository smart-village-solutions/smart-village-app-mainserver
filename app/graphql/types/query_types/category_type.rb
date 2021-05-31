# frozen_string_literal: true

module Types
  class QueryTypes::CategoryType < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: true
    field :generic_items_count, Integer, null: true
    field :points_of_interest_count, Integer, null: true
    field :tours_count, Integer, null: true
    field :news_items_count, Integer, null: true
    field :event_records_count, Integer, null: true
    field :upcoming_event_records_count, Integer, null: true
    field :event_records, [QueryTypes::EventRecordType], null: true
    field :upcoming_event_records, [QueryTypes::EventRecordType], null: true
    field :points_of_interest, [QueryTypes::PointOfInterestType], null: true
    field :tours, [QueryTypes::TourType], null: true
    field :news_items, [QueryTypes::NewsItemType], null: true
  end
end
