# frozen_string_literal: true

module Resolvers
  module Conversations
    class GetMessages < GraphQL::Schema::Resolver
      argument :conversation_id, ID, required: true

      type [Types::QueryTypes::Conversations::MessageType], null: false

      def resolve(conversation_id:)
        conversation = Messaging::Conversation.find_by(id: conversation_id)

        if conversation&.participants&.include?(context[:current_member])
          return conversation.messages.order(created_at: :desc)
        end

        Messaging::Message.none
      end
    end
  end
end
