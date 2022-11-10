# frozen_string_literal: true

module Mutations
  class SendPushNotification < BaseMutation
    argument :title, String, required: true
    argument :body, String, required: false
    argument :force_create, Boolean, required: false

    type Types::StatusType

    def resolve(**params)
      if params.include?(:title) && params[:title].present?
        PushNotification.delay.send_notifications(params)
      end

      OpenStruct.new(
        id: nil,
        status: "Push notifications successfully queued",
        status_code: 200
      )
    end
  end
end
