# frozen_string_literal: true

module Types
  class QueryTypes::Conversations::MessageType < Types::BaseObject
    field :id, GraphQL::Types::ID, null: true
    field :message_text, String, null: true
    field :sender_id, ID, null: true
    field :conversation_id, ID, null: true
  end
end
