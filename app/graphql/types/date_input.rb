# frozen_string_literal: true

module Types
  class DateInput < BaseInputObject
    argument :weekday, String, required: false
    argument :date_start, String, required: false
    argument :date_end, String, required: false
    argument :time_start, String, required: false
    argument :time_end, String, required: false
    argument :time_Description, String, required: false
    argument :use_only_time_description, Boolean, required: false
  end
end
