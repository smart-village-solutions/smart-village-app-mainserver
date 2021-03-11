# frozen_string_literal: true

module Types
  class InputTypes::CategoryInput < BaseInputObject
    argument :name, String, required: false
  end
end
