# frozen_string_literal: true

module Types
  class CategoryType < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: true
  end
end
