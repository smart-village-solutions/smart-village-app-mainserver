# frozen_string_literal: true

module Types
  class QueryTypes::ShoutOrganizerType < Types::BaseObject
    field :organizer_type, String, null: false
    field :organizer_id, ID, null: false
  end
end
