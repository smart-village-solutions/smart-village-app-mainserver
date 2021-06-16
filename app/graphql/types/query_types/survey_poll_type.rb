# frozen_string_literal: true

module Types
  class QueryTypes::SurveyPollType < Types::BaseObject
    field :id, ID, null: true
    field :title, QueryTypes::I18nTextType, null: true
    field :question_title, QueryTypes::I18nTextType, null: true
    field :description, QueryTypes::I18nTextType, null: true
    field :date, QueryTypes::DateType, null: true
    field :response_options, [QueryTypes::SurveyResponseOptionsType], null: true
    field :updated_at, String, null: true
    field :created_at, String, null: true
  end
end
