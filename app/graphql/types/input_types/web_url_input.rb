# frozen_string_literal: true

module Types
  class InputTypes::WebUrlInput < BaseInputObject
    argument :url, String, required: false
    argument :description, String, required: false
  end
end
