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
          .select("conversations.*, MAX(messages.created_at) as last_message_created_at")
          .group("conversations.id")
          .order("last_message_created_at DESC")
      end

      type [Types::QueryTypes::Conversations::ConversationType]
    end
  end
end
