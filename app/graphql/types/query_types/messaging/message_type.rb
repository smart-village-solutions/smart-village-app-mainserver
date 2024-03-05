# frozen_string_literal: true

module Types
  class QueryTypes::Messaging::MessageType < Types::BaseObject
    field :conversation_id, ID, null: false
    field :sender_id, ID, null: true
    field :message_text, String, null: true
  end
end
