# frozen_string_literal: true

module Messaging
  class CreateMessageService
    def initialize(params, current_member)
      @params = params
      @current_member = current_member
    end

    def call
      return error_response("Unable to create message without sender.") unless @current_member

      if params[:conversation_id].present?
        handle_existing_conversation
      else
        handle_new_conversation
      end
    end

    private

      attr_reader :params, :current_member

      def handle_existing_conversation
        conversation = find_conversation
        return error_response("Conversation does not exist") unless conversation

        message = create_message(conversation)
        message ? success_response(conversation) : error_response("Failed to create message")
      end

      def handle_new_conversation
        conversation = create_new_conversation
        return error_response("Resource owner does not exist") unless resource_author_id

        message = create_message(conversation)
        return error_response("Failed to create message") unless message

        add_participants(conversation)
        success_response(conversation)
      end

      def find_conversation
        Messaging::Conversation.find_by(id: params[:conversation_id])
      end

      def create_new_conversation
        conversation_params = {
          conversationable_id: params[:conversationable_id],
          conversationable_type: params[:conversationable_type]
        }
        Messaging::Conversation.create!(conversation_params)
      end

      def create_message(conversation)
        Messaging::Message.create!(
          conversation_id: conversation.id,
          message_text: params[:message_text],
          sender_id: current_member.id
        )
      end

      def resource_author_id
        klass = params[:conversationable_type].constantize
        klass.find_by(id: params[:conversationable_id]).try(:member_id)
      end

      def add_participants(conversation)
        [resource_author_id, current_member.id].each do |member_id|
          Messaging::ConversationParticipant.find_or_create_by!(conversation_id: conversation.id, member_id: member_id)
        end
      end

      def success_response(conversation)
        OpenStruct.new(id: conversation.id, status: "Message successfully created", status_code: 200)
      end

      def error_response(message, status_code = 422)
        OpenStruct.new(id: nil, status: message, status_code: status_code)
      end
  end
end
