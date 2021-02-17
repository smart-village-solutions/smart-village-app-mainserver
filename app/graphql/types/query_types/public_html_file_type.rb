# frozen_string_literal: true

module Types
  class QueryTypes::PublicHtmlFileType < Types::BaseObject
    field :name, String, null: true
    field :content, String, null: true
  end
end
