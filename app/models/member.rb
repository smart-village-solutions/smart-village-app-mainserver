class Member < ApplicationRecord
  include MunicipalityScope

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable,
  # :database_authenticatable, :omniauthable, :recoverable, :rememberable
  devise :database_authenticatable, :registerable, :validatable, :token_authenticatable, :omniauthable, omniauth_providers: [:keycloak_openid]

  has_many :redemptions, dependent: :destroy
  has_many :notification_devices, class_name: "Notification::Device", dependent: :destroy

  def self.from_omniauth(session_state:, session_code:) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    return nil if session_state.blank?
    return nil if session_code.blank?

    keycloak_service = Keycloak::RealmsService.new(MunicipalityService.municipality_id)
    keycloak_tokens = keycloak_service.get_keycloak_tokens(session_code)
    access_token = keycloak_tokens["access_token"]
    return nil if access_token.blank?

    keycloak_member_data = keycloak_service.get_keycloak_member_data(access_token)

    member = Member.where(
      municipality_id: MunicipalityService.municipality_id,
      keycloak_id: keycloak_member_data["sub"]
    ).first

    member ||= Member.create(
      municipality_id: MunicipalityService.municipality_id,
      keycloak_id: keycloak_member_data["sub"],
      email: keycloak_member_data["email"],
      password: Devise.friendly_token[0, 20]
    )

    # store keycloak access_token and refresh_token
    member.update(
      keycloak_access_token: access_token,
      keycloak_access_token_expires_at: Time.zone.at(Time.zone.now.to_i + keycloak_tokens["expires_in"].to_i),
      keycloak_refresh_token: keycloak_tokens["refresh_token"],
      keycloak_refresh_token_expires_at: Time.zone.at(Time.zone.now.to_i + keycloak_tokens["refresh_expires_in"].to_i)
    )

    member
  end

  def self.redirect_uri
    "https://#{MunicipalityService.slug}.#{ADMIN_URL}/members/auth/keycloak_openid/callback"
  end
end

# == Schema Information
#
# Table name: members
#
#  id                              :bigint           not null, primary key
#  keycloak_id                     :string(255)
#  municipality_id                 :integer
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  email                           :string(255)      default(""), not null
#  encrypted_password              :string(255)      default(""), not null
#  authentication_token            :text(65535)
#  authentication_token_created_at :datetime
#
