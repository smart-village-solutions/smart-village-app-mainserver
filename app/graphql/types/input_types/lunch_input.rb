# frozen_string_literal: true

module Types
  class InputTypes::LunchInput < BaseInputObject
    argument :text, String, required: false
    argument :dates, [Types::InputTypes::DateInput], required: false, as: :dates_attributes, prepare: ->(dates, _ctx) { dates.map(&:to_h) }
    argument :lunch_offers, [Types::InputTypes::LunchOfferInput], required: false, as: :lunch_offers_attributes, prepare: ->(lunch_offers, _ctx) { lunch_offers.map(&:to_h) }
    argument :point_of_interest_id, ID, required: false
    argument :point_of_interest_attributes, String, required: false
  end
end
