# frozen_string_literal: true

module Types
  class QueryTypes::PriceType < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: true
    field :category, String, null: true
    field :amount, Float, null: true
    field :group_price, Boolean, null: true
    field :age_from, Integer, null: true
    field :age_to, Integer, null: true
    field :min_adult_count, Integer, null: true
    field :max_adult_count, Integer, null: true
    field :min_children_count, Integer, null: true
    field :max_children_count, Integer, null: true
    field :description, String, null: true
  end
end
