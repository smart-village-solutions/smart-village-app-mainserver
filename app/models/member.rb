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

    keycloak_tokens = get_keycloak_tokens(session_code)
    access_token = keycloak_tokens["access_token"]
    return nil if access_token.blank?

    keycloak_member_data = get_keycloak_member_data(access_token)

    member = Member.where(keycloak_id: keycloak_member_data["sub"]).first

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

  def self.get_keycloak_member_data(access_token)
    keycloak_url = MunicipalityService.settings["member_keycloak_url"]
    keycloak_realm = MunicipalityService.settings["member_keycloak_realm"]
    uri = "#{keycloak_url}/realms/#{keycloak_realm}/protocol/openid-connect/userinfo"
    headers = { Authorization: "Bearer #{access_token}" }
    request_service = ApiRequestService.new(uri, nil, nil, nil, headers)
    response = request_service.get_request

    return nil if response.blank?
    return nil unless response.code == "200"
    return nil if response.body.blank?

    JSON.parse(response.body)
  end

  def self.get_keycloak_tokens(session_code) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    keycloak_url = MunicipalityService.settings["member_keycloak_url"]
    keycloak_realm = MunicipalityService.settings["member_keycloak_realm"]
    keycloak_client_id = MunicipalityService.settings["member_keycloak_client_id"]
    keycloak_client_secret = MunicipalityService.settings["member_keycloak_client_secret"]
    data = {
      grant_type: "authorization_code",
      client_id: keycloak_client_id,
      client_secret: keycloak_client_secret,
      code: session_code,
      redirect_uri: Member.redirect_uri
    }
    uri = "#{keycloak_url}/realms/#{keycloak_realm}/protocol/openid-connect/token"
    request_service = ApiRequestService.new(uri, nil, nil, data)
    response = request_service.form_post_request

    return nil if response.blank?
    return nil unless response.code == "200"
    return nil if response.body.blank?

    JSON.parse(response.body)
  end

  def self.redirect_uri
    "https://#{MunicipalityService.slug}.#{ADMIN_URL}/members/auth/keycloak_openid/callback"
  end

  # todo: refresh access_token
  #   response = HTTParty.post("https://keycloak-server/auth/realms/dein-realm/protocol/openid-connect/token",
  #                          body: {
  #                            client_id: 'dein-client-id',
  #                            client_secret: 'dein-client-geheimnis',
  #                            grant_type: 'refresh_token',
  #                            refresh_token: 'dein-aktuelles-refresh-token'
  #                          })
  # if response.success?
  #   new_access_token = response.parsed_response['access_token']
  #   # Speichere das neue Access Token
  # else
  #   # Fehlerbehandlung
  # end
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
