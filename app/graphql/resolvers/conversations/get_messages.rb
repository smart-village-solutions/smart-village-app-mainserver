# frozen_string_literal: true

module Resolvers
  module Conversations
    class GetMessages < GraphQL::Schema::Resolver
      argument :conversation_id, ID, required: true

      type [Types::QueryTypes::Conversations::MessageType], null: false

      def resolve(conversation_id:)
        conversation = Messaging::Conversation.find_by(id: conversation_id)
        return conversation.messages if conversation&.participants&.include?(context[:current_member])

        Messaging::Message.none
      end
    end
  end
end
