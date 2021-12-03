# frozen_string_literal: false

module Mutations
  class VoteForSurvey < BaseMutation
    description "`voteForSurvey` is deprecated. Use `votesForSurvey` instead."
    argument :increase_id, ID, required: false
    argument :decrease_id, ID, required: false

    type Types::StatusType

    def resolve(increase_id: nil, decrease_id: nil)
      ActiveSupport::Deprecation.warn("`VoteForSurvey` is deprecated. Use `VotesForSurvey` instead.")
      return error_status("Access not permitted: missing role") unless context[:current_user].app_role?
      return error_status("Missing ResponseOptionID as increase_id or decrease_id", 500) if increase_id.blank? && decrease_id.blank?

      begin
        increase_response = Survey::ResponseOption.find_by(id: increase_id) if increase_id.present?
        increase_response.increment!(:votes_count) if increase_response.present?

        decrease_response = Survey::ResponseOption.find_by(id: decrease_id) if decrease_id.present?
        decrease_response.decrement!(:votes_count) if decrease_response.present?

        OpenStruct.new(id: nil, status: "voted successfully, increased: #{increase_id} decreased: #{decrease_id}", status_code: 200)
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
