# frozen_string_literal: true

module Types
  class DestroyType < Types::BaseObject
    field :id, Integer, null: true
    field :status, String, null: true
    field :status_code, Integer, null: true
  end
end
