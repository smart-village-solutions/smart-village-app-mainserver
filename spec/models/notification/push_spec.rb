# frozen_string_literal: true

require "rails_helper"

RSpec.describe Notification::Push, type: :model do
  it { is_expected.to belong_to(:notification_pushable) }

  describe "recurring_count" do
    it "is 0 if once" do
      notification = FactoryBot.build(:notification_push_once)

      expect(notification.recurring_count).to eq(0)
    end

    it "is 1 if on one day" do
      notification = FactoryBot.build(:notification_push_mondays)

      expect(notification.recurring_count).to eq(1)
    end

    it "is 2 if on two days" do
      notification = FactoryBot.build(:notification_push_wednesdays_and_saturdays)

      expect(notification.recurring_count).to eq(2)
    end
  end
end
