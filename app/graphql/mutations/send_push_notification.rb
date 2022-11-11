# frozen_string_literal: true

module Mutations
  class SendPushNotification < BaseMutation
    argument :title, String, required: true
    argument :body, String, required: false
    argument :force_create, Boolean, required: false

    type Types::StatusType

    def resolve(**params)
      raise "Access not permitted" unless roles[:role_push_notification] == true

      if params.include?(:title) && params[:title].present?
        PushNotification.delay.send_notifications(params)
      end

      OpenStruct.new(
        id: nil,
        status: "Push notifications successfully queued",
        status_code: 200
      )
    end

    private

      def roles
        context[:current_user].try(:data_provider).try(:roles) || {}
      end
  end
end
