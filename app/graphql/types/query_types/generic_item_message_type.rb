# frozen_string_literal: true

module Types
  class QueryTypes::GenericItemMessageType < Types::BaseObject
    field :id, ID, null: true
    field :message, String, null: true
    field :visible, Boolean, null: true
  end
end
