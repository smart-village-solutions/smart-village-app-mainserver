# frozen_string_literal: false

module Mutations
  class DestroyRecord < BaseMutation
    argument :id, Integer, required: true
    argument :record_type, String, required: true

    type Types::DestroyType

    RECORD_WHITELIST = ["EventRecord", "NewsItem", "PointOfInterest", "Tour"].freeze

    def resolve(id:, record_type:)
      return error_status unless RECORD_WHITELIST.include?(record_type)

      record = record_type.constantize
                 .filtered_for_current_user(context[:current_user])
                 .where(id: id)
                 .first

      if record.present?
        record.destroy
        status = "Record destroyed"
        status_code = 200
      else
        status = "Record not found"
        status_code = 404
      end

      OpenStruct.new(id: id, status: status, status_code: status_code)
    end

    def error_status
      OpenStruct.new(id: nil, status: "Access not permitted", status_code: 403)
    end
  end
end
