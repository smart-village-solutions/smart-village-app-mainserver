# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :all_points_of_interest, [PointOfInterestType], null: false do
      argument :limit, Integer, required: false
      argument :order, String, required: false
    end
    field :point_of_interest, PointOfInterestType, null: false do
      argument :id, ID, required: true
    end
    field :all_event_records, [EventRecordType], null: false do
      argument :limit, Integer, required: false
      argument :order, String, required: false
    end
    field :event_record, EventRecordType, null: false do
      argument :id, ID, required: true
    end
    field :all_news_items, [NewsItemType], null: false do
      argument :limit, Integer, required: false
      argument :order, String, required: false
    end
    field :news_item, NewsItemType, null: false do
      argument :id, ID, required: true
    end
    field :tours, [TourType], null: false do
      argument :limit, Integer, required: false
      argument :order, String, required: false
    end
    field :tour, TourType, null: false do
      argument :id, ID, required: true
    end

    def all_points_of_interest(limit: nil, order: :id)
      PointOfInterest.all.limit(limit).order(order)
    end

    def point_of_interest(id:)
      PointOfInterest.find(id)
    end

    def all_event_records(limit: nil, order: :id)
      EventRecord.all.limit(limit).order(order)
    end

    def event_record(id:)
      EventRecord.find(id)
    end

    def all_news_items(limit: nil, order: :id)
      NewsItem.all.limit(limit).order(order)
    end

    def news_item(id:)
      NewsItem.find(id)
    end

    def tours(limit: nil, order: :id)
      Tour.all.limit(limit).order(order)
    end

    def tour(id:)
      Tour.find(id)
    end
  end
end
