# frozen_string_literal: true

module Types
  class InputTypes::DateInput < BaseInputObject
    argument :weekday, String, required: false
    argument :date_start, String, required: false
    argument :date_end, String, required: false
    argument :time_start, String, required: false
    argument :time_end, String, required: false
    argument :time_description, String, required: false
    argument :use_only_time_description, Boolean, required: false
  end
end
