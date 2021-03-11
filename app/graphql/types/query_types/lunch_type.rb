# frozen_string_literal: true

module Types
  class QueryTypes::LunchType < Types::BaseObject
    field :id, ID, null: true
    field :text, String, null: true
    field :list_date, String, null: true
    field :dates, [QueryTypes::DateType], null: true
    field :lunch_offers, [QueryTypes::LunchOfferType], null: true
    field :point_of_interest, QueryTypes::PointOfInterestType, null: false
    field :point_of_interest_attributes, String, null: true
    field :updated_at, String, null: true
    field :created_at, String, null: true
  end
end
