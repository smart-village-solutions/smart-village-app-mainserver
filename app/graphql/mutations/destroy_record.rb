# frozen_string_literal: false

module Mutations
  class DestroyRecord < BaseMutation
    argument :id, Integer, required: false
    argument :record_type, String, required: true
    argument :external_id, Integer, required: false

    type Types::DestroyType

    RECORD_WHITELIST = ["EventRecord", "NewsItem", "PointOfInterest", "Tour"].freeze

    def resolve(id: nil, record_type:, external_id: nil)
      return error_status unless RECORD_WHITELIST.include?(record_type)

      record = if external_id.present?
                 find_record(record_type, external_id: external_id)
               else
                 find_record(record_type, id: id)
               end
      destroy_record(record)
      id ||= record.try(:id)

      OpenStruct.new(id: id, status: status, status_code: status_code)
    end

    def error_status
      OpenStruct.new(id: nil, status: "Access not permitted", status_code: 403)
    end

    def find_record(record_type, search_hash)
      record_type.constantize
        .filtered_for_current_user(context[:current_user])
        .where(search_hash)
        .first
    end

    def destroy_record(record)
      if record.present?
        record.destroy
        status = "Record destroyed"
        status_code = 200
      else
        status = "Record not found"
        status_code = 404
      end
    end
  end
end
