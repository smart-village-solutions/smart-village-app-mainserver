module Types
  class InputTypes::DiscountTypeInput < BaseInputObject
    argument :original_price, Float, required: false
    argument :discounted_price, Float, required: false
    argument :discount_percentage, Float, required: false
    argument :discount_amount, Float, required: false
  end
end
