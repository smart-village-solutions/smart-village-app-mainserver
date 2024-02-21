# frozen_string_literal: true

class Member < ApplicationRecord
  include MunicipalityScope

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable,
  # :database_authenticatable, :omniauthable, :recoverable, :rememberable
  devise :database_authenticatable, :registerable, :validatable, :token_authenticatable, :omniauthable, :recoverable,
         omniauth_providers: [:keycloak_openid]

  store :preferences,
        accessors: %i[
          membership_start_date
          membership_level
          gender
          birthday
          street
          postcode
          city
        ],
        coder: JSON

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
    member.update_keycloak_tokens(access_token: access_token, keycloak_tokens: keycloak_tokens)

    member
  end

  def update_keycloak_tokens(keycloak_tokens: {}, access_token: nil) # rubocop:disable Metrics/AbcSize
    update_columns(keycloak_access_token: access_token) if access_token.present?
    return unless keycloak_tokens.present?

    update_columns(
      keycloak_access_token_expires_at: Time.zone.at(Time.zone.now.to_i + keycloak_tokens["expires_in"].to_i),
      keycloak_refresh_token: keycloak_tokens["refresh_token"],
      keycloak_refresh_token_expires_at: Time.zone.at(Time.zone.now.to_i + keycloak_tokens["refresh_expires_in"].to_i)
    )
  end

  def self.redirect_uri
    "https://#{MunicipalityService.slug}.#{ADMIN_URL}/members/auth/keycloak_openid/callback"
  end

  def self.find_for_authentication(warden_conditions) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    subdomains = Array(warden_conditions.fetch(:subdomain, "").to_s.try(:split, "."))

    municipality_service = MunicipalityService.new(subdomains: subdomains)
    @current_municipality = municipality_service.municipality if municipality_service.subdomain_valid?
    MunicipalityService.municipality_id = @current_municipality.id if @current_municipality.present?

    if @current_municipality.present?
      params = warden_conditions[:email].present? ? { email: warden_conditions[:email] } : {}
      if warden_conditions[:authentication_token].present?
        params.merge!(authentication_token: warden_conditions[:authentication_token])
      end

      return where(params).first
    end

    where("1 == 0")
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
