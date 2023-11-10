# frozen_string_literal: true

FactoryBot.define do
  factory :notification_device, class: "Notification::Device" do
    id { 1 }
    token { "RandomToken" }
    device_type { 0 }
    exclude_data_provider_ids { nil }
    exclude_mowas_regional_keys { nil }
  end
end

# == Schema Information
#
# Table name: notification_devices
#
#  id                          :bigint           not null, primary key
#  token                       :string(255)
#  device_type                 :integer          default("undefined")
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  exclude_data_provider_ids   :text(65535)
#  exclude_mowas_regional_keys :text(65535)
#
