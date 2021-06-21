# frozen_string_literal: true

module Types
  class QueryTypes::SurveyPollType < Types::BaseObject
    field :id, ID, null: true
    field :title, QueryTypes::I18nJSON, null: true
    field :question_id, ID, null: true
    field :question_title, QueryTypes::I18nJSON, null: true
    field :description, QueryTypes::I18nJSON, null: true
    field :date, QueryTypes::DateType, null: true
    field :response_options, [QueryTypes::SurveyResponseOptionsType], null: true
    field :data_provider, QueryTypes::DataProviderType, null: true
    field :visible, Boolean, null: true
    field :updated_at, String, null: true
    field :created_at, String, null: true
  end
end
