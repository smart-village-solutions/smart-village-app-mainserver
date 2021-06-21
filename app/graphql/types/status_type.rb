# frozen_string_literal: true

module Types
  class StatusType < Types::BaseObject
    field :id, ID, null: true
    field :status, String, null: true
    field :status_code, Integer, null: true
  end
end
