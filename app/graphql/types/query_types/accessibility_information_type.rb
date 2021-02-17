# frozen_string_literal: true

module Types
  class QueryTypes::AccessibilityInformationType < Types::BaseObject
    field :id, ID, null: true
    field :description, String, null: true
    field :types, String, null: true
    field :urls, [QueryTypes::WebUrlType], null: true
  end
end
