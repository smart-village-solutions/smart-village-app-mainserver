# frozen_string_literal: true

module Types
  class QueryTypes::PushNotificationType < Types::BaseObject
    field :notification_pushable_type, String, null: false
    field :notification_pushable_id, Integer, null: false
    field :once_at, String, null: true
    field :monday_at, String, null: true
    field :tuesday_at, String, null: true
    field :wednesday_at, String, null: true
    field :thursday_at, String, null: true
    field :friday_at, String, null: true
    field :saturday_at, String, null: true
    field :sunday_at, String, null: true
    field :recurring, Integer, null: true
    field :title, String, null: false
    field :body, String, null: true
    field :data, QueryTypes::PushNotificationDataType, null: true
  end
end
