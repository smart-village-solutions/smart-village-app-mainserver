# frozen_string_literal: true

# This module provides a method to destroy a record or a collection of records.
# It is used in the DestroyRecord mutation and in the WastePickUpTime.
module RecordDestruction
  extend ActiveSupport::Concern

  def destroy_record(record)
    return not_found_response if record.nil?

    if record.destroy
      build_response(id: record.id, status: "Record destroyed", status_code: 200)
    else
      build_response(id: record.id, status: record.errors.full_messages.join(", "), status_code: 500)
    end
  end

  def destroy_records(records)
    count = records.count

    return not_found_response if count.zero?

    destroyed_count = records.destroy_all.count
    if destroyed_count == count
      build_response(status: "#{destroyed_count} records destroyed", status_code: 200)
    else
      build_response(status: "Some records could not be destroyed", status_code: 500)
    end
  end

  private

    def build_response(id: nil, status:, status_code:)
      OpenStruct.new(id: id, status: status, status_code: status_code)
    end

    def not_found_response
      build_response(status: "Record not found", status_code: 404)
    end
end
