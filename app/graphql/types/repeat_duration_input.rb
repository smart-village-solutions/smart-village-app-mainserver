module Types
  class RepeatDurationInput < BaseInputObject
    argument :start_date, String, required: false
    argument :end_date, String, required: false
    argument :every_year, Boolean, required: false
  end
end