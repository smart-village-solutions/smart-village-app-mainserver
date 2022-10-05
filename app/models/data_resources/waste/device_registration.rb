# frozen_string_literal: true

class Waste::DeviceRegistration < ApplicationRecord
  belongs_to :notification_device, class_name: "Notification::Device", foreign_key: "notification_device_token", primary_key: "token", optional: true

  def notify_at_time
    return nil if notify_at.blank?

    notify_at.localtime.to_s(:time)
  end
end

# == Schema Information
#
# Table name: waste_device_registrations
#
#  id                        :bigint           not null, primary key
#  notification_device_token :string(255)
#  street                    :string(255)
#  city                      :string(255)
#  zip                       :string(255)
#  notify_days_before        :integer          default(0)
#  notify_at                 :time
#  notify_for_waste_type     :string(255)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
