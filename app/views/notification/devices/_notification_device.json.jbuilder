json.extract! notification_device, :id, :token, :device_type, :created_at, :updated_at
json.url notification_device_url(notification_device, format: :json)
