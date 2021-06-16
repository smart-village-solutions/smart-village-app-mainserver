# frozen_string_literal: true

module Types
  class QueryTypes::SurveyType < Types::BaseObject
    field :all, [QueryTypes::SurveyPollType], null: true
    field :active, [QueryTypes::SurveyPollType], null: true
    field :archived, [QueryTypes::SurveyPollType], null: true
  end
end
