# frozen_string_literal: true

module Types
  class InputTypes::OpeningHourInput < BaseInputObject
    argument :weekday, String, required: false
    argument :date_from, String, required: false
    argument :date_to, String, required: false
    argument :time_from, String, required: false
    argument :time_to, String, required: false
    argument :sort_number, Integer, required: false
    argument :open, Boolean, required: false
    argument :use_year, Boolean, required: false
    argument :description, String, required: false
  end
end
