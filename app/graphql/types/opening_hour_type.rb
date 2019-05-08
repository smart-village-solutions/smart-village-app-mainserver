# frozen_string_literal: true

module Types
  class OpeningHourType < Types::BaseObject
    field :id, ID, null: false
    field :weekday, String, null: true
    field :date_from, String, null: true
    field :date_to, String, null: true
    field :time_from, String, null: true
    field :time_to, String, null: true
    field :sort_number, Integer, null: true
    field :open, Boolean, null: true
    field :description, String, null: true
  end
end