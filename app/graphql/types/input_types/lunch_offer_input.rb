# frozen_string_literal: true

module Types
  class InputTypes::LunchOfferInput < BaseInputObject
    argument :name, String, required: false
    argument :price, String, required: false
  end
end
