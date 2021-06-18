# frozen_string_literal: false

module Mutations
  class CreateSurveyPoll < BaseMutation
    argument :force_create, Boolean, required: false
    argument :title, Types::QueryTypes::I18nJSON, required: false
    argument :description, Types::QueryTypes::I18nJSON, required: false
    argument :date,
             Types::InputTypes::DateInput,
             required: false,
             as: :date_attributes,
             prepare: ->(date, _ctx) { date.to_h }
    argument :questionTitle, Types::QueryTypes::I18nJSON, required: true
    argument :response_options, [GraphQL::Types::JSON], required: true

    field :survey_poll, Types::QueryTypes::SurveyPollType, null: true

    type Types::QueryTypes::SurveyPollType

    def resolve(**params)
      if context.present?
        params = params.merge(data_provider: context[:current_user].try(:data_provider))
      end

      # delete params that shouldn't be passed to creation, because they are unknown to the model
      question_title = params.delete(:question_title)
      response_options = params.delete(:response_options)

      # build questions_attributes from question_title and response_options
      params = params.merge(
        questions_attributes: [{
          title: question_title,
          response_options_attributes: response_options
        }]
      )

      Survey::Poll.create(params)
    end
  end
end
