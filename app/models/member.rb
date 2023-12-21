class Member < ApplicationRecord
  include MunicipalityScope

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable,
  # :database_authenticatable, :omniauthable, :recoverable, :rememberable
  devise :database_authenticatable, :registerable, :validatable, :omniauthable, :token_authenticatable

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
