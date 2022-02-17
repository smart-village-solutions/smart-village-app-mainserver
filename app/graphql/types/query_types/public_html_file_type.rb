# frozen_string_literal: true

module Types
  class QueryTypes::PublicHtmlFileType < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: true
    field :content, String, null: true
    field :data_type, String, null: true
    field :version, String, null: true
    field :updated_at, String, null: true
    field :created_at, String, null: true
  end
end
