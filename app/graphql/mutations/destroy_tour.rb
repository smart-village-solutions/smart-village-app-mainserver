# frozen_string_literal: false

module Mutations
  class DestroyTour < BaseMutation
    argument :id, Integer, required: true

    type Types::TourType

    def resolve(id:)
      Tour.find(id).destroy
    end
  end
end