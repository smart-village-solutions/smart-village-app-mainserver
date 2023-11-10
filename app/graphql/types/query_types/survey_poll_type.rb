# frozen_string_literal: true

module Types
  class QueryTypes::SurveyPollType < Types::BaseObject
    field :id, ID, null: true
    field :survey_comments, [QueryTypes::SurveyComment], null: true
    field :title, QueryTypes::I18nJSON, null: true
    field :question_id, ID, null: true
    field :question_title, QueryTypes::I18nJSON, null: true
    field :question_allow_multiple_responses, Boolean, null: true
    field :description, QueryTypes::I18nJSON, null: true
    field :date, QueryTypes::DateType, null: true
    field :response_options, [QueryTypes::SurveyResponseOptionsType], null: true
    field :data_provider, QueryTypes::DataProviderType, null: true
    field :visible, Boolean, null: true
    field :can_comment, Boolean, null: true
    field :is_multilingual, Boolean, null: true
    field :updated_at, String, null: true
    field :created_at, String, null: true

    def survey_comments
      object.comments.filtered_for_current_user(context[:current_user])
    end
  end
end
