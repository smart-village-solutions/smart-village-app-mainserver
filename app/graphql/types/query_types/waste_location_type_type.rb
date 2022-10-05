# frozen_string_literal: true

module Types
  class QueryTypes::WasteLocationTypeType < Types::BaseObject
    field :id, ID, null: true
    field :waste_type, String, null: true
    field :list_pick_up_dates, [String], null: true
    field :pick_up_times, [QueryTypes::WastePickUpTimeType], null: true
    field :address, QueryTypes::AddressType, null: true
    field :address_id, Integer, null: true
    field :updated_at, String, null: true
    field :created_at, String, null: true
    field :waste_tour, QueryTypes::WasteTourType, null: true
  end
end
