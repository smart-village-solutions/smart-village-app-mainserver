# frozen_string_literal: true

# This class work with messaging flow, once you send all needed data
# It will automatically create a conversation and return conversation data
# rubocop:disable all
module Mutations
  module Conversations
    class CreateMessage < BaseMutation
      argument :conversationable_id, ID, required: false
      argument :conversationable_type, String, required: false
      argument :message_text, String, required: true
      argument :conversation_id, ID, required: false

      type Types::StatusType

      def resolve(**params)
        Messaging::CreateMessageService.new(params, context[:current_member]).call
      end
    end
  end
end


# Query example
# mutation(
#   $conversationableId: ID!,
#   $conversationableType: String!,
#   $messageText: String!
# ) {
#   createMessage(
#     conversationableId: $conversationableId,
#     conversationableType: $conversationableType,
#     messageText: $messageText
#   ) {
#     id
#     status
#     statusCode
#   }
# }