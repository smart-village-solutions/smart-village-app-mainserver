# frozen_string_literal: true

module Types
  class QueryTypes::DiscountType < Types::BaseObject
    field :id, ID, null: true
    field :original_price, Float, null: true
    field :discounted_price, Float, null: true
    field :discount_percentage, Float, null: true
    field :discount_amount, Float, null: true
  end
end
