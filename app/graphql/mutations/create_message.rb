# frozen_string_literal: true

# This class work with messaging flow, once you send all needed data
# It will automatically create a conversation and return conversation data
# rubocop:disable all
module Mutations
  class CreateMessage < BaseMutation
    argument :conversationable_id, ID, required: true
    argument :conversationable_type, String, required: true
    argument :message_text, String, required: true

    type Types::StatusType

    # TODO: I will improve and refactor all thiw tomorrow morning :)
    def resolve(**params)
      return error_status("Unable to create message without sender.") unless context[:current_member]
      
      klass = params[:conversationable_type].constantize
      resource_owner_id = klass.find_by(id: params[:conversationable_id]).try(:member_id)

      return error_status("Resource owner does not exists") unless resource_owner_id

      conversation_params = {
        conversationable_id: params[:conversationable_id],
        conversationable_type: params[:conversationable_type],
        owner_id: context[:current_member].try(:id)
      }

      conversation = Messaging::Conversation.find_or_create_by!(conversation_params)
      message = Messaging::Message.create!(
        conversation_id: conversation.try(:id),
        message_text: params[:message_text],
        sender_id: context[:current_member].try(:id)
      )
      
      Messaging::ConversationParticipant.find_or_create_by!(conversation_id: conversation.id, member_id: resource_owner_id)
      Messaging::ConversationParticipant.find_or_create_by!(conversation_id: conversation.id, member_id: context[:current_member].try(:id))


      OpenStruct.new(id: conversation.id, status: "Message successfully created", status_code: 200)

    end

    private
      def error_status(description, status_code = 422)
        OpenStruct.new(id: nil, status: description, status_code: status_code)
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