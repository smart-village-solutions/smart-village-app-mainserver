# frozen_string_literal: true

module Types
  class QueryTypes::LunchOfferType < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: true
    field :price, String, null: true
    field :updated_at, String, null: true
    field :created_at, String, null: true
  end
end
