# frozen_string_literal: true

module Types
  class InputTypes::RegionInput < BaseInputObject
    argument :name, String, required: false
  end
end
