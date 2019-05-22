# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :createTour, mutation: Mutations::CreateTour
    field :create_point_of_interest, mutation: Mutations::CreatePointOfInterest
  end
end
