# frozen_string_literal: true

module Mutations
  module Conversations
    class MarkMessagesAsRead < BaseMutation
      argument :message_id, ID, required: false
      argument :conversation_id, ID, required: false
      argument :update_all_messages, Boolean, required: false

      type Types::StatusType

      def resolve(message_id: nil, conversation_id: nil, update_all_messages: false)
        return error_status("Access not permitted", 403) unless context[:current_member]

        return mark_message_as_read(message_id) if message_id

        mark_conversation_as_read(conversation_id) if conversation_id && update_all_messages
      end

      private

        # Update one receipt for specific message for current member
        def mark_message_as_read(message_id)
          message = Messaging::Message.find_by(id: message_id)
          receipt = message.receipts.find_by(member: context[:current_member])
          if receipt&.update(read: true)
            success_status(id: message_id)
          else
            error_status("Message not found or already read")
          end
        end

        # Update all receipts for specific conversation for current member
        def mark_conversation_as_read(conversation_id)
          conversation = Messaging::Conversation.find_by(id: conversation_id)
          return error_status("Conversation not found") unless conversation

          receipts = Messaging::Receipt
                     .joins(:message)
                     .where(messages: { conversation_id: conversation_id }, member: context[:current_member], read: false)

          if receipts.update_all(read: true)
            success_status(id: conversation_id)
          else
            error_status("Error during conversation read update")
          end
        end

        def error_status(description, status_code = 422)
          OpenStruct.new(id: nil, status: description, status_code: status_code)
        end

        def success_status(id:)
          OpenStruct.new(id: id, status: "Message successfully marked as read", status_code: 200)
        end
    end
  end
end
