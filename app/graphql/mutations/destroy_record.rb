# frozen_string_literal: false

module Mutations
  class DestroyRecord < BaseMutation
    include RecordDestruction

    argument :id, GraphQL::Types::ID, required: false
    argument :record_type, String, required: true
    argument :external_id, Integer, required: false

    type Types::DestroyType

    RECORD_WHITELIST = [
      "EventRecord",
      "NewsItem",
      "PointOfInterest",
      "Tour",
      "GenericItem",
      "Survey::Poll",
      "StaticContent",
      "Waste::Tour",
      "Address"
    ].freeze

    # method destroy_record comes from RecordDestruction concern and return a builded response object
    def resolve(id: nil, record_type:, external_id: nil)
      raise "Access not permitted" if context[:current_user].read_only_role?
      return error_status unless RECORD_WHITELIST.include?(record_type)

      record = if external_id.present?
                 find_record(record_type, external_id: external_id)
               else
                 find_record(record_type, id: id)
               end
      result = destroy_record(record)
      id ||= record.try(:id)

      # Delete event from external service if record is an EventRecord
      if record_type == "EventRecord"
        ExternalServices::EventRecords::EventSyncService.new(current_user, record).delete_event
      end

      OpenStruct.new(id: id, status: result[:status], status_code: result[:status_code])
    end

    private

      def error_status
        OpenStruct.new(id: nil, status: "Access not permitted", status_code: 403)
      end

      def find_record(record_type, search_hash)
        record_type.constantize
          .filtered_for_current_user(context[:current_user])
          .where(search_hash)
          .first
      end
  end
end
