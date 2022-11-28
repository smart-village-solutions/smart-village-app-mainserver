# frozen_string_literal: true

require "rails_helper"

RSpec.describe SendSinglePushNotificationJob, type: :job do
  it "cleans up notification device" do
    device_token = "ExponentPushToken[RkCuwM123456778g29lQb0ZK]"
    device = Notification::Device.create(token: device_token)
    payload = "{\"data\":[{\"status\":\"error\",\"message\":\"The recipient device is not registered with FCM.\",\"details\":{\"error\":\"DeviceNotRegistered\",\"fault\":\"developer\"}}]}"

    SendSinglePushNotificationJob.new.cleanup_if_unregistered_device(device_token, payload)

    expect(Notification::Device.all).not_to include(device)
  end
end
