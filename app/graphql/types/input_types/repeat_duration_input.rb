# frozen_string_literal: true

module Types
  class InputTypes::RepeatDurationInput < BaseInputObject
    argument :start_date, String, required: false
    argument :end_date, String, required: false
    argument :every_year, Boolean, required: false
  end
end
