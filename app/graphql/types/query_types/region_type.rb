# frozen_string_literal: true

module Types
  class QueryTypes::RegionType < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: true
  end
end
