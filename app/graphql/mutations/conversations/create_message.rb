# frozen_string_literal: true

module Mutations
  module Conversations
    class CreateMessage < BaseMutation
      argument :conversationable_id, ID, required: false
      argument :conversationable_type, String, required: false
      argument :message_text, String, required: true
      argument :conversation_id, ID, required: false

      type Types::StatusType

      # Messaging::CreateMessageService check if the conversation_id is present
      # If yes it will create a new message and add it to existing conversation
      # Else it will create a new conversation and add the message to it(and add participants).
      def resolve(**params)
        return unauthorized_status unless context[:current_member]

        Messaging::CreateMessageService.new(params, context[:current_member]).call
      end

      private

        def unauthorized_status
          OpenStruct.new(id: nil, status: "Access not permitted", status_code: 401)
        end
    end
  end
end
