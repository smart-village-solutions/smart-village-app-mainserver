# frozen_string_literal: false

module Mutations
  class CreateOrUpdateSurveyPoll < BaseMutation
    argument :force_create, Boolean, required: false
    argument :id, ID, required: false
    argument :title, Types::QueryTypes::I18nJSON, required: false
    argument :description, Types::QueryTypes::I18nJSON, required: false
    argument :date,
             Types::InputTypes::DateInput,
             required: false,
             as: :date_attributes,
             prepare: ->(date, _ctx) { date.to_h }
    argument :questionId, ID, required: false
    argument :questionTitle, Types::QueryTypes::I18nJSON, required: true
    argument :questionAllowMultipleResponses, Types::QueryTypes::I18nJSON, required: false
    argument :response_options, [GraphQL::Types::JSON], required: true
    argument :can_comment, Boolean, required: false
    argument :is_multilingual, Boolean, required: false

    field :survey_poll, Types::QueryTypes::SurveyPollType, null: true

    type Types::QueryTypes::SurveyPollType

    def resolve(**params)
      if context.present?
        params = params.merge(data_provider: context[:current_user].try(:data_provider))
      end

      # delete params that shouldn't be passed to creation, because they are unknown to the model
      question_id = params.delete(:question_id)
      question_title = params.delete(:question_title)
      question_allow_multiple_responses = params.delete(:question_allow_multiple_responses)
      response_options = params.delete(:response_options)

      # build questions_attributes from question_title and response_options
      params = params.merge(
        questions_attributes: [{
          id: question_id,
          title: question_title,
          allow_multiple_responses: question_allow_multiple_responses,
          response_options_attributes: response_options
        }]
      )

      create_or_update(params)
    end

    private

      def create_or_update(params)
        survey_id = params.delete(:id)

        if survey_id.present?
          survey = Survey::Poll.filtered_for_current_user(context[:current_user])
                     .find_by(id: survey_id)
          survey&.update(params)
        else
          survey = Survey::Poll.create(params)
        end

        resource_or_error_message(survey)
      end

      def resource_or_error_message(record)
        return {} if record.blank?

        if record.valid?
          record
        else
          GraphQL::ExecutionError.new("Invalid input: #{record.errors.full_messages.join(", ")}")
        end
      end
  end
end
