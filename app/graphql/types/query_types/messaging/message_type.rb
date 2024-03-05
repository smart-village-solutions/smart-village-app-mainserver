# frozen_string_literal: true

module Types
  class QueryTypes::Messaging::MessageType < Types::BaseObject
    field :conversation_id, ID, null: false
    field :member_id, ID, null: true, description: "This is sender identifier"
    field :message_text, String, null: true
  end
end
