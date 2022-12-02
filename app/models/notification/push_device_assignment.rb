# frozen_string_literal: true

class Notification::PushDeviceAssignment < ApplicationRecord
  belongs_to :notification_push, class_name: "Notification::Push"
  belongs_to :notification_device, class_name: "Notification::Device"

  validates_presence_of :notification_push
  validates_presence_of :notification_device
  validates_uniqueness_of :notification_push, scope: :notification_device
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
