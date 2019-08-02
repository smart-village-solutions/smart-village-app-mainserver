# frozen_string_literal: true

module Types
  class CategoryType < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: true
    field :points_of_interest_count, Integer, null: true
    field :tours_count, Integer, null: true
  end
end
