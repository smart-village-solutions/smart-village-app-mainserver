# app/graphql/resolvers/get_current_member_conversations.rb

require "search_object/plugin/graphql"

module Resolvers
  module Conversations
    class GetConversations < GraphQL::Schema::Resolver
      include SearchObject.module(:graphql)

      scope { context[:current_member].conversations }

      type [Types::QueryTypes::Conversations::ConversationType]

      option :ids, type: types[GraphQL::Types::ID], with: :apply_ids_filter

      def apply_ids_filter(scope, value)
        scope.where(id: value)
      end
    end
  end
end
