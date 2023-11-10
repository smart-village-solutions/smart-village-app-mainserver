# frozen_string_literal: true

require "rails_helper"

RSpec.describe Notification::Device, type: :model do
  it { is_expected.to have_many(:waste_registrations) }
  it { is_expected.to have_many(:pushes) }
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
