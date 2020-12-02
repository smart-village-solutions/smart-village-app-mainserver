# frozen_string_literal: false

module Mutations
  class ChangeVisibility < BaseMutation
    argument :id, ID, required: true
    argument :record_type, String, required: true
    argument :visible, Boolean, required: true

    type Types::ChangeVisibilityType

    RECORD_WHITELIST = ["EventRecord", "NewsItem", "PointOfInterest", "Tour"].freeze

    def resolve(id:, record_type:, visible:)
      return error_status("recordType") unless RECORD_WHITELIST.include?(record_type)
      return error_status("visible") unless [true, false].include?(visible)

      record = record_type.constantize
                 .filtered_for_current_user(context[:current_user])
                 .where(id: id)
                 .first
      return error_status("record blank") if record.blank?

      record.update(visible: visible)

      OpenStruct.new(id: id, status: "visibility set to #{visible}", status_code: 200)
    end

    private

      def error_status(description)
        OpenStruct.new(id: nil, status: "Access not permitted: #{description}", status_code: 403)
      end
  end
end
