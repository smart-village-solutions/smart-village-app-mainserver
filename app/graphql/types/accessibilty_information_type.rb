# frozen_string_literal: true

module Types
  class AccessibiltyInformationType < Types::BaseObject
    field :id, ID, null: false
    field :description, String, null: true
    field :types, String, null: true
    field :urls, [WebUrlType], null: true
  end
end
