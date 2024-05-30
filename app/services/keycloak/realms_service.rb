# Mögliche GEMS für die Entwicklung:
# https://github.com/ccrockett/omniauth-keycloak
# https://github.com/looorent/keycloak-api-rails
# https://www.keycloak.org/docs-api/22.0.5/rest-api/index.html

# https://keycloak.smart-village.app/realms/sva-saas/
# https://keycloak.smart-village.app/realms/sva-saas/account/#/
# https://keycloak.smart-village.app/realms/sva-saas/protocol/openid-connect/auth?client_id=account-console&redirect_uri=https%3A%2F%2Fkeycloak.smart-village.app%2Frealms%2FSVA-SaaS%2Faccount%2F%23%2Fsecurity%2Fdevice-activity&state=8684b22e-d037-42ea-bc0d-019633b3c001&response_mode=fragment&response_type=code&scope=openid&nonce=d580c775-6dc2-4b21-83a9-d28c8c85c428&code_challenge=x6Vx7qzwsABR5rVdVxZs6AOasRIRnLlN5gcj8BQeFb0&code_challenge_method=S256

class Keycloak::RealmsService # rubocop:disable Metrics/ClassLength
  attr_accessor :realm, :uri, :master_token_path, :admin_username,
                :admin_password, :client_id, :client_secret, :municipality_id,
                :municipality_settings

  # Konfiguration ist hier zu finden:
  # https://keycloak.smart-village.app/realms/master/.well-known/openid-configuration
  def initialize(municipality_id)
    @municipality_id = municipality_id
    @municipality_settings = Municipality.find_by(id: @municipality_id).try(:settings) || {}
    @client_id = @municipality_settings[:member_keycloak_client_id]
    @client_secret = @municipality_settings[:member_keycloak_client_secret]
    @realm = @municipality_settings[:member_keycloak_realm]
    @uri = @municipality_settings[:member_keycloak_url]
    @master_token_path = "/realms/master/protocol/openid-connect/token"
    @admin_username = @municipality_settings[:member_keycloak_admin_username]
    @admin_password = @municipality_settings[:member_keycloak_admin_password]
  end

  # List of all realms in Keycloak
  def index
    request = ApiRequestService.new([uri, "/admin/realms"].join, nil, nil, nil, auth_headers)
    result = request.get_request
    JSON.parse(result.body) if result.code == "200"
  end

  def create_realm
  end

  def update_realm
  end

  def reset_password(email)
    keycloak_id = Member.find_by(email: email).try(:keycloak_id)
    send_password_reset_email(keycloak_id) if keycloak_id.present?
  end

  def create_user(member_params) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    keycloak_user_params = {
      username: member_params[:email],
      email: member_params[:email],
      emailVerified: false,
      enabled: true,
      firstName: member_params[:first_name],
      lastName: member_params[:last_name],
      credentials: [
        {
          type: "password",
          value: member_params[:password],
          temporary: false
        }
      ],
      requiredActions: ["VERIFY_EMAIL"]
    }
    request = ApiRequestService.new([uri, "/admin/realms/#{realm}/users"].join, nil, nil, keycloak_user_params, auth_headers)
    result = request.post_request

    if result.code == "201"
      keycloak_id = result.fetch("Location", "").split("/").last
      # Create local Member if not exists synced with Keycloak user
      @resource = Member.where(municipality_id: municipality_id, email: member_params[:email]).first_or_create do |member|
        member_password = SecureRandom.alphanumeric
        member.municipality_id = municipality_id
        member.password = member_password
        member.password_confirmation = member_password
      end

      @resource.update(keycloak_id: keycloak_id, authentication_token_created_at: Time.zone.now)

      send_verification_email(keycloak_id)

      return @resource
    end

    JSON.parse(result.body)
  end

  def update_user(new_member_params, member) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    return nil if member.blank?
    return nil if member.keycloak_id.blank?

    new_member_params = map_member_params_to_keycloak_user_attributes(new_member_params)
    old_keycloak_user_data = get_keycloak_member_data(member.keycloak_access_token)

    request = ApiRequestService.new([uri, "/admin/realms/#{realm}/users/#{member.keycloak_id}"].join, nil, nil, new_member_params, auth_headers)
    result = request.put_request

    if email_changed?(new_member_params, member, old_keycloak_user_data)
      send_verification_email(member.keycloak_id)
      member.update_columns(email: new_member_params["email"], authentication_token_created_at: Time.zone.now)
    end

    { errors: nil, success: true } if result.code == "204"
  end

  def login_user(member_params) # rubocop:disable Metrics/MethodLength
    keycloak_user_params = {
      grant_type: "password",
      client_id: client_id,
      client_secret: client_secret,
      username: member_params[:email],
      password: member_params[:password],
      scope: "openid profile email"
    }
    request = ApiRequestService.new([uri, "/realms/#{realm}/protocol/openid-connect/token"].join, nil, nil, keycloak_user_params, {content_type: "application/x-www-form-urlencoded" })
    result = request.form_post_request
    JSON.parse(result.body)
  end

  def get_keycloak_tokens(session_code) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    data = {
      grant_type: "authorization_code",
      client_id: client_id,
      client_secret: client_secret,
      code: session_code,
      redirect_uri: Member.redirect_uri,
      scope: "openid profile email"
    }
    request_service = ApiRequestService.new("#{uri}/realms/#{realm}/protocol/openid-connect/token", nil, nil, data)
    response = request_service.form_post_request

    return nil if response.blank?
    return nil unless response.code == "200"
    return nil if response.body.blank?

    JSON.parse(response.body)
  end

  def get_keycloak_member_data(access_token)
    headers = { Authorization: "Bearer #{access_token}" }
    request_service = ApiRequestService.new("#{uri}/realms/#{realm}/protocol/openid-connect/userinfo", nil, nil, nil, headers)
    response = request_service.get_request

    return nil if response.blank?
    return nil unless response.code == "200"
    return nil if response.body.blank?

    JSON.parse(response.body)
  end

  # curl -X POST \
  # http://keycloak-server/auth/realms/{realm}/protocol/openid-connect/token \
  # -H 'Content-Type: application/x-www-form-urlencoded' \
  # -d 'client_id=deine-client-id&refresh_token=dein-refresh-token&grant_type=refresh_token&client_secret=dein-client-secret'
  def refresh_user_token(refresh_token)
    data = {
      grant_type: "refresh_token",
      client_id: client_id,
      client_secret: client_secret,
      refresh_token: refresh_token,
      scope: "openid profile email"
    }
    request_service = ApiRequestService.new("#{uri}/realms/#{realm}/protocol/openid-connect/token", nil, {}, data)
    response = request_service.form_post_request
    JSON.parse(response.body)
  end

  private

    # Helper Method to validate token access
    def introspect_token(token)
      data = {
        grant_type: "refresh_token",
        client_id: client_id,
        client_secret: client_secret,
        token: token
      }
      request_service = ApiRequestService.new("#{uri}/realms/#{realm}/protocol/openid-connect/token/introspect", nil, {}, data)
      response = request_service.form_post_request
      JSON.parse(response.body)
    end

    # 2 Sources of emails are possible: keycloak and local member
    # All 3 emails have to be checked: new_member_params, member.email and keycloak["email"]
    def email_changed?(new_member_params, member, old_keycloak_user_data)
      return false if new_member_params.blank?
      return false if member.blank?
      return false if new_member_params["email"].blank?
      return false if member.email.blank?

      new_member_params["email"] != member.email || new_member_params["email"] != old_keycloak_user_data.fetch("email", "")
    end

    # Send email to the user with the link to confirm the new email address
    def send_verification_email(keycloak_id)
      request = ApiRequestService.new([uri, "/admin/realms/#{realm}/users/#{keycloak_id}/execute-actions-email"].join, nil, nil, ["VERIFY_EMAIL"], auth_headers)
      request.put_request
    end

    # Send email to the user with the link to reset the password
    def send_password_reset_email(keycloak_id)
      request = ApiRequestService.new([uri, "/admin/realms/#{realm}/users/#{keycloak_id}/execute-actions-email"].join, nil, nil, ["UPDATE_PASSWORD"], auth_headers)
      request.put_request
    end

    def map_member_params_to_keycloak_user_attributes(member_params)
      # rewrite key of new_member_params first_name to firstName
      member_params["firstName"] = member_params.delete("first_name")

      # rewrite key of new_member_params last_name to lastName
      member_params["lastName"] = member_params.delete("last_name")

      member_params
    end

    def token_from_keycloak
      auth_params = {
        grant_type: "password",
        client_id: "admin-cli",
        username: @admin_username,
        password: @admin_password
      }
      auth_headers = { content_type: "application/x-www-form-urlencoded" }
      request = ApiRequestService.new([uri, master_token_path].join, nil, nil, auth_params, auth_headers)
      result = request.form_post_request

      JSON.parse(result.body) if result.code == "200"
    end

    def auth_headers
      { "Authorization": "Bearer #{token_from_keycloak["access_token"]}"}
    end
end
