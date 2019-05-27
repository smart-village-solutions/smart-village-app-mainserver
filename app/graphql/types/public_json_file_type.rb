# frozen_string_literal: true

module Types
  class PublicJsonFileType < Types::BaseObject
    field :name, String, null: false
    field :content, String, null: false
  end
end
