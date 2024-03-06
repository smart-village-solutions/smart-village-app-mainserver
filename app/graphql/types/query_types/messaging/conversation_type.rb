# frozen_string_literal: true

module Types
  class QueryTypes::Messaging::ConversationType < Types::BaseObject
    field :conversationable_id, ID, null: false
    field :conversationable_type, String, null: false
  end
end
