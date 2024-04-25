# frozen_string_literal: true

json.extract! notification_device, :id, :token, :device_type, :member_id, :created_at, :updated_at,
                                   :exclude_data_provider_ids, :exclude_mowas_regional_keys, :exclude_notification_configuration
json.url notification_device_url(notification_device, format: :json)
