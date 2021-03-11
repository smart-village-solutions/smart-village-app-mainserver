# frozen_string_literal: true

module Types
  class QueryTypes::RepeatDurationType < Types::BaseObject
    field :id, ID, null: true
    field :start_date, String, null: true
    field :end_date, String, null: true
    field :every_year, Boolean, null: true
  end
end
