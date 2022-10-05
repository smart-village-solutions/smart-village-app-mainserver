# frozen_string_literal: true

module Types
  class QueryTypes::WasteTourType < Types::BaseObject
    field :id, ID, null: true
    field :title, String, null: true
    field :waste_type, String, null: true
  end
end
