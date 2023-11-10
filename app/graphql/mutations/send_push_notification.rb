# frozen_string_literal: true

module Mutations
  class SendPushNotification < BaseMutation
    argument :title, String, required: true
    argument :body, String, required: false
    argument :data, Types::InputTypes::PushNotificationDataInput, required: false
    argument :force_create, Boolean, required: false

    type Types::StatusType

    def resolve(title:, body: nil, data: { data_provider_id: nil, payload: nil }, force_create: nil)
      raise "Access not permitted" unless roles[:role_push_notification] == true

      message_options = { title: title }
      message_options[:body] = body if body.present?

      if data.present?
        message_options[:data] = {}

        if data.data_provider_id.present?
          message_options[:data][:data_provider_id] = data.data_provider_id.to_i
        end

        if data.mowas_regional_keys.present?
          message_options[:data][:mowas_regional_keys] = data.mowas_regional_keys
        end
      end

      PushNotification.delay.send_notifications(message_options) if title.present?

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
