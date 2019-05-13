# frozen_string_literal: true

module Types
  class DateType < Types::BaseObject
    field :id, ID, null: false
    field :weekday, String, null: true
    field :date_start, String, null: true
    field :date_end, String, null: true
    field :time_start, String, null: true
    field :time_end, String, null: true
    field :time_Description, String, null: true
    field :use_only_time_description, String, null: true
  end
end
