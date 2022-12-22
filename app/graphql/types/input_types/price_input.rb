# frozen_string_literal: true

module Types
  class InputTypes::PriceInput < BaseInputObject
    argument :name, String, required: false
    argument :amount, Float, required: false
    argument :group_price, Boolean, required: false
    argument :age_from, Integer, required: false
    argument :age_to, Integer, required: false
    argument :min_adult_count, Integer, required: false
    argument :max_adult_count, Integer, required: false
    argument :min_children_count, Integer, required: false
    argument :max_children_count, Integer, required: false
    argument :description, String, required: false
    argument :category, String, required: false
  end
end
