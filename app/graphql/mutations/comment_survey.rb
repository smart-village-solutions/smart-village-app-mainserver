# frozen_string_literal: false

module Mutations
  class CommentSurvey < BaseMutation
    argument :survey_id, ID, required: true
    argument :message, String, required: true

    type Types::StatusType

    def resolve(survey_id:, message:)
      survey = Survey::Poll.find_by(id: survey_id)

      return error_status("Access not permitted: Survey missing") if survey.blank?
      return error_status("Access not permitted: Survey already archived") if survey.archived?

      comment = survey.comments.build(message: message)
      return error_status("Access not permitted: Comment invalid, #{comment.error_messages}") unless comment.valid?

      begin
        comment.save
        NotificationMailer.survey_commented(comment, survey).deliver_later
        OpenStruct.new(id: comment.id, status: "commented survey #{survey_id} successfully", status_code: 200)
      rescue => e
        error_status("Error on commenting: #{e}", 500)
      end
    end

    private

      def error_status(description, status_code = 403)
        OpenStruct.new(id: nil, status: description, status_code: status_code)
      end
  end
end
