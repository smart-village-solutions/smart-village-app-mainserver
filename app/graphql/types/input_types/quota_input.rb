module Types
  class InputTypes::QuotaInput < BaseInputObject
    argument :max_quantity, Integer, required: false
    argument :frequency, String, required: false
    argument :max_per_person, Integer, required: false
  end
end
