# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :all_points_of_interest, [PointOfInterestType], null: false
    field :poi, PointOfInterestType, null: false do
      argument :id, ID, required: true
    end
    field :all_event_records, [EventRecordType], null: false
    field :event_record, EventRecordType, null: false do
      argument :id, ID, required: true
    end


    def all_points_of_interest
      PointOfInterest.all
    end

    def poi(id:)
      PointOfInterest.find(id)
    end

    def all_event_records
      EventRecord.all
    end

    def event_record(id:)
      EventRecord.find(id)
    end
  end
end
