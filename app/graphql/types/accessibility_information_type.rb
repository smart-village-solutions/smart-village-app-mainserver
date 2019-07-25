# frozen_string_literal: true

module Types
  class AccessibilityInformationType < Types::BaseObject
    field :id, ID, null: true
    field :description, String, null: true
    field :types, String, null: true
    field :urls, [WebUrlType], null: true
  end
end
