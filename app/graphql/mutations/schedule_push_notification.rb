# frozen_string_literal: true

module Mutations
  class SchedulePushNotification < BaseMutation
    argument :notification_pushable_type, String, required: true
    argument :notification_pushable_id, Integer, required: true
    argument :once_at, String, required: false
    argument :monday_at, String, required: false
    argument :tuesday_at, String, required: false
    argument :wednesday_at, String, required: false
    argument :thursday_at, String, required: false
    argument :friday_at, String, required: false
    argument :saturday_at, String, required: false
    argument :sunday_at, String, required: false
    argument :recurring, Integer, required: false
    argument :title, String, required: true
    argument :body, String, required: false
    argument :data, Types::InputTypes::PushNotificationDataInput, required: false
    argument :force_create, Boolean, required: false

    type Types::StatusType

    RECORD_WHITELIST = [
      "EventRecord",
      "GenericItem",
      "NewsItem",
      "PointOfInterest",
      "Tour"
    ].freeze

    def resolve(**params)
      raise "Access not permitted" unless roles[:role_push_notification] == true
      return GraphQL::ExecutionError.new("Request not valid") unless valid?(params)

      push_notification = Notification::Push.create(
        notification_pushable_type: params[:notification_pushable_type],
        notification_pushable_id: params[:notification_pushable_id],
        once_at: params[:once_at],
        monday_at: params[:monday_at],
        tuesday_at: params[:tuesday_at],
        wednesday_at: params[:wednesday_at],
        thursday_at: params[:thursday_at],
        friday_at: params[:friday_at],
        saturday_at: params[:saturday_at],
        sunday_at: params[:sunday_at],
        recurring: params[:recurring],
        title: params[:title],
        body: params[:body],
        data: {
          id: params.dig(:data, :id) || params[:notification_pushable_id],
          query_type: params.dig(:data, :query_type) || params[:notification_pushable_type]
        },
        force_create: params[:force_create]
      )

      unless push_notification.valid?
        return GraphQL::ExecutionError.new(
          "Request not valid: #{push_notification.errors.full_messages.join(", ")}"
        )
      end

      OpenStruct.new(
        id: push_notification.id,
        status: "Push notifications successfully scheduled",
        status_code: 200
      )
    end

    private

      def roles
        context[:current_user].try(:data_provider).try(:roles) || {}
      end

      def valid?(params)
        RECORD_WHITELIST.include?(params[:notification_pushable_type]) &&
          params[:notification_pushable_type].present? &&
          params[:notification_pushable_id].present? &&
          params[:recurring].present? && (
            (params[:recurring].to_i.zero? && params[:once_at].present?) ||
            params[:recurring].to_i.positive?
          ) &&
          params[:title].present?
      end
  end
end
