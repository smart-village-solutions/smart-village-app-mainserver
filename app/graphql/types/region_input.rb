# frozen_string_literal: true

module Types
  class RegionInput < BaseInputObject
    argument :name, String, required: false
  end
end
