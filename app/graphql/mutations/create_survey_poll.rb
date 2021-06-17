# frozen_string_literal: false

module Mutations
  class CreateSurveyPoll < BaseMutation
    argument :title, GraphQL::Types::JSON, required: false
    argument :description, GraphQL::Types::JSON, required: false
    argument :date,
             Types::InputTypes::DateInput,
             required: false,
             as: :date_attributes,
             prepare: ->(date, _ctx) { date.to_h }
    argument :questionTitle, GraphQL::Types::JSON, required: true
    argument :response_options, [GraphQL::Types::JSON], required: true

    field :survey_poll, Types::QueryTypes::SurveyPollType, null: true

    type Types::QueryTypes::SurveyPollType

    def resolve(**params)
      if context.present?
        params = params.merge(data_provider: context[:current_user].try(:data_provider))
      end

      # build questions_attributes from question_title and response_options
      params = params.merge(
        questions_attributes: [{
          title: params[:question_title],
          response_options_attributes: params[:response_options]
        }]
      )
      # delete params that shouldn't be passed to creation, because they are unknown to the model
      params.delete(:question_title)
      params.delete(:response_options)

      Survey::Poll.create(params)
    end
  end
end
