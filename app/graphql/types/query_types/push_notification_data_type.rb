# frozen_string_literal: true

module Types
  class QueryTypes::PushNotificationDataType < Types::BaseObject
    field :id, ID, null: true
    field :query_type, String, null: true
    field :data_provider_id, ID, null: true
  end
end
