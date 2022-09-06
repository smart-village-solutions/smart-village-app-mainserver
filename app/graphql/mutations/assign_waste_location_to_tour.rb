# frozen_string_literal: true

module Mutations
  class AssignWasteLocationToTour < BaseMutation
    argument :id, ID, required: false
    argument :force_create, Boolean, required: false
    argument :tour_id, ID, required: false
    argument :tour_value, Boolean, required: false
    argument :address_id, ID, required: false

    field :id, ID, null: false

    def resolve(**params)
      tour = Waste::Tour.find(params[:tour_id])
      waste_location_type = Waste::LocationType.where(
        address_id: params[:address_id],
        waste_tour_id: tour.id
      )
      if params[:tour_value] == true
        waste_location_type = waste_location_type.first_or_create(waste_type: tour.waste_type)
        # Add Dates to PickupLocation
        dates_to_add = tour.pick_up_times.map(&:pickup_date).flatten.compact.uniq
        dates_to_add.each do |pickup_date|
          Waste::PickUpTime.where(waste_location_type_id: waste_location_type.id, pickup_date: pickup_date).first_or_create
        end
      end

      if params[:tour_value] == false && waste_location_type.any?
        waste_location_type = waste_location_type.first.destroy
      end

      OpenStruct.new(id: waste_location_type.try(:id).presence || 0, status: "Tour assigned to location", status_code: 200)
    end

  end
end
