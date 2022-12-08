# frozen_string_literal: true

FactoryBot.define do
  factory :notification_push_device_assignment, class: "Notification::PushDeviceAssignment" do
    notification_push_id { 1 }
    notification_device_id { 1 }
  end
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
