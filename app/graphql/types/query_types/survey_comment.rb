# frozen_string_literal: true

module Types
  class QueryTypes::SurveyComment < Types::BaseObject
    field :id, ID, null: true
    field :survey_poll_id, ID, null: true
    field :message, String, null: true
    field :amount, Float, null: true
    field :visible, Boolean, null: true
  end
end
