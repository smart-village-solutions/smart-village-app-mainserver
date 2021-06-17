# frozen_string_literal: true

module Types
  class QueryTypes::SurveyResponseOptionsType < Types::BaseObject
    field :id, ID, null: true
    field :title, QueryTypes::I18nJSON, null: true
    field :votes_count, Integer, null: true
    field :updated_at, String, null: true
    field :created_at, String, null: true
  end
end
