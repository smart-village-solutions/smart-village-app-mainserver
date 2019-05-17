# frozen_string_literal: true

module Mutations
  class CreatePointOfInterest < BaseMutation
    argument :name, String, required: true
    argument :description, String, required: false
    argument :mobile_description, String, required: false
    argument :active, Boolean, required: false
    argument :category_id, Integer, required: false
    argument :addresses, [Types::AddressInput], required: false, as: :addresses_attributes, prepare: ->(addresses, ctx) { addresses.map(&:to_h) }
    argument :contact, Types::ContactInput, required: false, as: :contact_attributes, prepare: ->(contact, ctx) { contact.to_h}

    field :point_of_interest, Types::PointOfInterestType, null: false

    type Types::PointOfInterestType

    def resolve(**params)
      PointOfInterest.create!(params)
    end
  end
end
