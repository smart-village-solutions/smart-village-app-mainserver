# frozen_string_literal: true

module Types
  class QueryTypes::QuotaType < Types::BaseObject
    field :id, ID, null: true
    field :max_quantity, Integer, null: true
    field :frequency, String, null: true
    field :max_per_person, Integer, null: true
    field :available_quantity, Integer, null: true
    field :visibility, String, null: true
    field :available_quantity_for_member, Integer, null: true do
      argument :member_id, ID, required: false
    end
  end
end
