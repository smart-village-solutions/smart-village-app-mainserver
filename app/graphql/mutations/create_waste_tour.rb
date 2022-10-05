# frozen_string_literal: true

module Mutations
  class CreateWasteTour < BaseMutation
    argument :id, ID, required: false
    argument :force_create, Boolean, required: false
    argument :title, String, required: false
    argument :waste_type, String, required: false

    field :waste_tour, Types::QueryTypes::WasteTourType, null: false

    type Types::QueryTypes::WasteTourType

    def resolve(**params)
      if params.include?(:id) && params[:id].present?
        waste_tour = Waste::Tour.find(params[:id])
        waste_tour.update(params)
      else
        waste_tour = Waste::Tour.create(params)
      end

      OpenStruct.new(id: waste_tour.id, status: "Waste::Tour created", status_code: 200)
    end

  end
end
