# frozen_string_literal: false

module Mutations
  class DestroyPointOfInterest < BaseMutation
    argument :id, Integer, required: true

    type Types::PointOfInterestType

    def resolve(id:)
      PointOfInterest.find(id).destroy
    end
  end
end