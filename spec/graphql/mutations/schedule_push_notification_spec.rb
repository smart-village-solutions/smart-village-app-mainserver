# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::SchedulePushNotification do
  def perform(**args)
    user = create(:user)
    data_provider = create(:data_provider, roles: { role_push_notification: true })
    user.data_provider = data_provider
    user.save

    Mutations::SchedulePushNotification.new(
      object: nil,
      field: nil,
      context: { current_user: user }
    ).resolve(args)
  end

  describe "once" do
    it "successfully schedules a push notification" do
      push_notification = perform(
        notification_pushable_type: "GenericItem",
        notification_pushable_id: 1,
        once_at: "2022-12-24 12:00:00",
        recurring: 0,
        title: "Title",
        body: "Body"
      )

      expect(push_notification.status_code).to be(200)
    end

    it "fails scheduling a one time push notification with bad type" do
      push_notification = perform(
        notification_pushable_type: "BadType",
        notification_pushable_id: 1,
        once_at: "2022-12-24 12:00:00",
        recurring: 0,
        title: "Title",
        body: "Body"
      )

      expect(push_notification.message).to eq("Request not valid")
    end
  end

  describe "recurring" do
    it "successfully schedules a recurring push notification" do
      push_notification = perform(
        notification_pushable_type: "GenericItem",
        notification_pushable_id: 1,
        recurring: 1,
        monday_at: "14:00",
        title: "Title",
        body: "Body"
      )

      expect(push_notification.status_code).to be(200)
    end

    it "fails scheduling a recurring push notification with bad type" do
      push_notification = perform(
        notification_pushable_type: "BadType",
        notification_pushable_id: 1,
        recurring: 1,
        monday_at: "14:00",
        title: "Title",
        body: "Body"
      )

      expect(push_notification.message).to eq("Request not valid")
    end

    it "fails scheduling a recurring push notification" do
      push_notification = perform(
        notification_pushable_type: "GenericItem",
        notification_pushable_id: 1,
        recurring: 1,
        title: "Title",
        body: "Body"
      )

      expect(push_notification.message).to eq("Request not valid: Recurring count must be greater than 0")
    end
  end
end
