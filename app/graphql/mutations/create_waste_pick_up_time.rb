# frozen_string_literal: true

module Mutations
  class CreateWastePickUpTime < BaseMutation
    argument :pickup_date, String, required: true
    argument :waste_location_type_id, Integer, required: false
    argument :waste_location_type, Types::InputTypes::WasteLocationTypeInput, required: false,
             as: :waste_location_type_attributes,
             prepare: lambda { |address, _ctx|
                        address.to_h
                      }

    field :waste_pick_up_time, Types::QueryTypes::WastePickUpTimeType, null: true

    type Types::QueryTypes::WastePickUpTimeType

    def resolve(**params)
      waste_location_type_attributes = params.delete(:waste_location_type_attributes)

      address = Address.joins(:waste_location_types).where(waste_location_type_attributes[:address_attributes]).first_or_create
      waste_location_type = Waste::LocationType.where(address_id: address.id, waste_type: waste_location_type_attributes[:waste_type] ).first_or_create

      Waste::PickUpTime.where(params.merge(waste_location_type_id: waste_location_type.id)).first_or_create
    end
  end
end
