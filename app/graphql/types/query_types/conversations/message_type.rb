# frozen_string_literal: true

module Types
  class QueryTypes::Conversations::MessageType < Types::BaseObject
    field :id, GraphQL::Types::ID, null: true
    field :message_text, String, null: true
    field :sender_id, ID, null: true
    field :sender_name, String, null: true
    field :conversation_id, ID, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: true

    def sender_name
      object.sender.public_name
    end
  end
end
