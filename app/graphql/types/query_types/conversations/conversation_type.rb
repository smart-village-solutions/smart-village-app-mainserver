# frozen_string_literal: true

module Types
  class QueryTypes::Conversations::ConversationType < Types::BaseObject
    field :id, GraphQL::Types::ID, null: true
    field :conversationable_id, ID, null: true
    field :conversationable_type, String, null: true
    field :total_messages_count, Integer, null: true
    field :participants_count, Integer, null: true
    field :unread_messages_count, Integer, null: true
    field :latest_message, Types::QueryTypes::Conversations::MessageType, null: true

    def total_messages_count
      object.messages.count
    end

    def participants_count
      object.participants.count
    end

    def unread_messages_count
      object.unread_messages_count(context[:current_member])
    end

    def latest_message
      object.messages.order(created_at: :desc).first
    end

  end
end