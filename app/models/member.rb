class Member < ApplicationRecord
  has_many :redemptions, dependent: :destroy
  has_many :notification_devices, class_name: "Notification::Device", dependent: :destroy
end

# == Schema Information
#
# Table name: members
#
#  id              :bigint           not null, primary key
#  keycloak_id     :string(255)
#  municipality_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
