# frozen_string_literal: true

module Types
  class InputTypes::CategoryInput < BaseInputObject
    argument :name, String, required: false
    argument :payload, GraphQL::Types::JSON, required: false
    argument :children, [Types::InputTypes::CategoryInput], required: false
  end
end
