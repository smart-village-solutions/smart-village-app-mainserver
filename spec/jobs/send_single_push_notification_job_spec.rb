# frozen_string_literal: true

require "rails_helper"

RSpec.describe SendSinglePushNotificationJob, type: :job do
  it "performs" do
    device_token = "ExponentPushToken[RkCuwM123456778g29lQb0ZK]"
    Notification::Device.create(token: device_token)
    message_options = {}

    expect do
      SendSinglePushNotificationJob.perform_now(device_token, message_options)
    end.not_to raise_error
  end

  it "performs later" do
    device_token = "ExponentPushToken[RkCuwM123456778g29lQb0ZK]"
    Notification::Device.create(token: device_token)
    message_options = {}

    expect do
      SendSinglePushNotificationJob.perform_later(device_token, message_options)
    end.not_to raise_error
  end

  it "performs delayed" do
    device_token = "ExponentPushToken[RkCuwM123456778g29lQb0ZK]"
    Notification::Device.create(token: device_token)
    message_options = {}

    expect do
      SendSinglePushNotificationJob.delay(run_at: Time.now).perform(device_token, message_options)
    end.not_to raise_error
  end

  it "cleans up notification device" do
    device_token = "ExponentPushToken[RkCuwM123456778g29lQb0ZK]"
    device = Notification::Device.create(token: device_token)
    payload = "{\"data\":[{\"status\":\"error\",\"message\":\"The recipient device is not registered with FCM.\",\"details\":{\"error\":\"DeviceNotRegistered\",\"fault\":\"developer\"}}]}"

    SendSinglePushNotificationJob.new.cleanup_if_unregistered_device(device_token, payload)

    expect(Notification::Device.all).not_to include(device)
  end
end
