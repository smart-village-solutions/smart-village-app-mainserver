# frozen_string_literal: true

module Types
  class PointOfInterestType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :description, String, null: true
    field :mobile_description, String, null: true
    field :active, Boolean, null: true
    field :adresses, [AdressType], null: false
    field :category_id, Integer, null: false
    field :updated_at, String, null: true
    field :created_at, String, null: true
  end
end
