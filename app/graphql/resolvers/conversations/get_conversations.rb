# app/graphql/resolvers/get_current_member_conversations.rb

require "search_object/plugin/graphql"

module Resolvers
  module Conversations
    class GetConversations < GraphQL::Schema::Resolver
      include SearchObject.module(:graphql)

      scope do
        context[:current_member]
          .conversations
          .joins(:messages)
          .select("messaging_conversations.*, MAX(messaging_messages.created_at) as last_message_created_at")
          .group("messaging_conversations.id")
          .order("last_message_created_at DESC")
      end

      type [Types::QueryTypes::Conversations::ConversationType]

      option :conversationable_id, type: GraphQL::Types::ID, with: :apply_conversationable_id
      option :conversationable_type, type: GraphQL::Types::String, with: :apply_conversationable_type

      def apply_conversationable_id(scope, value)
        scope.where(conversationable_id: value)
      end

      def apply_conversationable_type(scope, value)
        scope.where(conversationable_type: value)
      end
    end
  end
end
