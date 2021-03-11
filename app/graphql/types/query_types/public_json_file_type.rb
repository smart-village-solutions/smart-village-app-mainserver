# frozen_string_literal: true

module Types
  class QueryTypes::PublicJsonFileType < Types::BaseObject
    field :name, String, null: false
    field :content, String, null: false
  end
end
