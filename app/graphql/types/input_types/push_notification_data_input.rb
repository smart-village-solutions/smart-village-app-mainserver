# frozen_string_literal: true

module Types
  class InputTypes::PushNotificationDataInput < BaseInputObject
    argument :id, ID, required: false
    argument :query_type, String, required: false
    argument :data_provider_id, ID, required: false
    argument :mowas_regional_keys, [AnyPrimitiveType], required: false
  end
end
