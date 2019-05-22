# frozen_string_literal: true

module Types
  class RepeatDurationType < Types::BaseObject
    field :id, ID, null: false
    field :start_date, String, null: true
    field :end_date, String, null: true
    field :every_year, Boolean, null: true
  end
end
