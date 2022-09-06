# frozen_string_literal: true

module Mutations
  class UpdateWasteTourDates < BaseMutation
    argument :id, ID, required: true
    argument :year, String, required: true
    argument :dates, [String], required: false

    field :id, ID, null: false

    def resolve(**params)
      waste_tour = Waste::Tour.find(params[:id])
      waste_location_type_ids = waste_tour.waste_location_type_ids
      start_date = Date.parse("#{params[:year]}-01-01")
      end_date = Date.parse("#{params[:year]}-12-31")

      # Delete all existing dates
      Waste::PickUpTime.where("pickup_date <= ? AND pickup_date >= ?", end_date, start_date).where(waste_location_type_id: waste_location_type_ids).destroy_all
      Waste::PickUpTime.where("pickup_date <= ? AND pickup_date >= ?", end_date, start_date).where(waste_tour_id: waste_tour.id).destroy_all

      # Create new dates
      pickup_dates = params[:dates]
      pickup_dates.each do |pickup_date|
        Waste::PickUpTime.create(waste_tour_id: waste_tour.id, pickup_date: pickup_date)
        waste_location_type_ids.each do |waste_location_type_id|
          Waste::PickUpTime.create(waste_location_type_id: waste_location_type_id, pickup_date: pickup_date)
        end
      end

      OpenStruct.new(id: waste_tour.id, status: "Waste::Tour created", status_code: 200)
    end

  end
end
