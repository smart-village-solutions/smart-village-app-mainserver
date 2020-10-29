# frozen_string_literal: true

module Types
  class CategoryType < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: true
    field :points_of_interest_count, Integer, null: true
    field :tours_count, Integer, null: true
    field :news_items_count, Integer, null: true
    field :event_records_count, Integer, null: true
    field :event_records, [EventRecordType], null: true
    field :points_of_interest, [PointOfInterestType], null: true
    field :tours, [TourType], null: true
    field :news_items, [NewsItemType], null: true
  end
end
