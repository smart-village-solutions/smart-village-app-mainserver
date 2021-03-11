# frozen_string_literal: true

module Types
  class QueryTypes::WastePickUpTimeType < Types::BaseObject
    field :id, ID, null: true
    field :pickup_date, String, null: true
    field :waste_location_type, QueryTypes::WasteLocationTypeType, null: true
    field :waste_location_type_id, ID, null: true
    field :updated_at, String, null: true
    field :created_at, String, null: true
  end
end
