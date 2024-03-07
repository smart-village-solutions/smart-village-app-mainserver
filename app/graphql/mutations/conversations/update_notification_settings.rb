# frozen_string_literal: true

module Mutations
  module Conversations
    class UpdateNotificationSettings < BaseMutation
      argument :conversation_id, ID, required: true
      argument :push_notification_enabled, Boolean, required: false
      argument :email_notification_enabled, Boolean, required: false

      type Types::StatusType

      def resolve(**params)
        return error_status("Access not permitted") unless context[:current_member]

        notification_settings = params.except(:conversation_id)
        relation_to_update = context[:current_member]&.conversation_participants&.find_by(conversation_id: params[:conversation_id])

        return error_status("Settings can't be updated") unless relation_to_update

        begin
          relation_to_update.update!(notification_settings)
          OpenStruct.new(id: nil, status: "Notification settings successfully updated", status_code: 200)
        rescue => e
          error_status("Error during notification settings update: #{e}", 500)
        end
      end

      private

        def error_status(description, status_code = 422)
          OpenStruct.new(id: nil, status: description, status_code: status_code)
        end
    end
  end
end
