# frozen_string_literal: true

require "rails_helper"

RSpec.describe Notification::PushDeviceAssignment, type: :model do
  it { is_expected.to belong_to(:notification_push) }
  it { is_expected.to belong_to(:notification_device) }
  it { is_expected.to validate_presence_of(:notification_push) }
  it { is_expected.to validate_presence_of(:notification_device) }
end

# == Schema Information
#
# Table name: notification_push_device_assignments
#
#  id                     :bigint           not null, primary key
#  notification_push_id   :integer
#  notification_device_id :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
