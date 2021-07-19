# frozen_string_literal: true

module Types
  class QueryTypes::SurveyComment < Types::BaseObject
    field :id, ID, null: true
    field :survey_poll_id, ID, null: true
    field :message, String, null: true
    field :visible, Boolean, null: true
    field :created_at, String, null: true
  end
end
