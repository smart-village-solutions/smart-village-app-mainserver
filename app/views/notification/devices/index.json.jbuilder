# frozen_string_literal: true

json.array! @notification_devices,
            partial: "notification_devices/notification_device",
            as: :notification_device
