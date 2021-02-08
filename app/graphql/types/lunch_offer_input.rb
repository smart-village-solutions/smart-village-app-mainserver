# frozen_string_literal: true

module Types
  class LunchOfferInput < BaseInputObject
    argument :name, String, required: false
    argument :price, String, required: false
  end
end
