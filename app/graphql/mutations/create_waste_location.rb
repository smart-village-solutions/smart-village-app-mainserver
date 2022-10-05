# frozen_string_literal: true

module Mutations
  class CreateWasteLocation < BaseMutation
    argument :id, ID, required: false
    argument :force_create, Boolean, required: false
    argument :street, String, required: false
    argument :city, String, required: false
    argument :zip, String, required: false

    field :address, Types::QueryTypes::AddressType, null: false

    type Types::QueryTypes::AddressType

    def resolve(**params)
      if params.include?(:id) && params[:id].present?
        address = Address.find_by(id: params[:id])
        address.update(params)
      else
        address = Address.create(params)
      end

      waste_location_type = Waste::LocationType.where(waste_type: "setup", address_id: address.id).first_or_create

      OpenStruct.new(id: address.id, status: "Address created", status_code: 200)
    end

  end
end
