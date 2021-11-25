# frozen_string_literal: false

module Mutations
  class VotesForSurvey < BaseMutation
    argument :increase_id, [ID], required: false
    argument :decrease_id, [ID], required: false

    type Types::StatusType

    def resolve(increase_id: nil, decrease_id: nil)
      return error_status("Access not permitted: missing role") unless context[:current_user].app_role?
      return error_status("Missing ResponseOptionID as increase_id or decrease_id", 500) if increase_id.blank? && decrease_id.blank?

      begin
        increase_responses = Survey::ResponseOption.where(id: increase_id) if increase_id.present?
        if increase_responses.present?
          increased_ids = []
          increase_responses.each do |increase_response|
            if increase_response.present?
              increase_response.increment!(:votes_count)
              increased_ids.push(increase_response.id)
            end
          end
        end

        decrease_responses = Survey::ResponseOption.where(id: decrease_id) if decrease_id.present?
        if decrease_responses.present?
          decreased_ids = []
          decrease_responses.each do |decrease_response|
            if decrease_response.present?
              decrease_response.decrement!(:votes_count)
              decreased_ids.push(decrease_response.id)
            end
          end
        end

        OpenStruct.new(
          id: nil,
          status: "voted successfully, increased: #{increased_ids} decreased: #{decreased_ids}",
          status_code: 200
        )
      rescue => e
        error_status("Error on voting: #{e}", 500)
      end
    end

    private

      def error_status(description, status_code = 403)
        OpenStruct.new(id: nil, status: description, status_code: status_code)
      end
  end
end
