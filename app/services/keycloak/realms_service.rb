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

      @resource.update(keycloak_id: keycloak_id)

      # Sende E-Mail an den Benutzer mit dem Link zum Bestätigen der E-Mail-Adresse
      request = ApiRequestService.new([uri, "/admin/realms/#{realm}/users/#{keycloak_id}/execute-actions-email"].join, nil, nil, ["VERIFY_EMAIL"], auth_headers)
      request.put_request

      return @resource
    end

    JSON.parse(result.body)
  end

  def update_user(member_params)
    # todo update user in keycloak
  end

  def login_user(member_params) # rubocop:disable Metrics/MethodLength
    keycloak_user_params = {
      grant_type: "password",
      client_id: client_id,
      client_secret: client_secret,
      username: member_params[:email],
      password: member_params[:password]
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
      redirect_uri: Member.redirect_uri
    }
    uri = "#{uri}/realms/#{realm}/protocol/openid-connect/token"
    request_service = ApiRequestService.new(uri, nil, nil, data)
    response = request_service.form_post_request

    return nil if response.blank?
    return nil unless response.code == "200"
    return nil if response.body.blank?

    JSON.parse(response.body)
  end

  def get_keycloak_member_data(access_token)
    uri = "#{uri}/realms/#{realm}/protocol/openid-connect/userinfo"
    headers = { Authorization: "Bearer #{access_token}" }
    request_service = ApiRequestService.new(uri, nil, nil, nil, headers)
    response = request_service.get_request

    return nil if response.blank?
    return nil unless response.code == "200"
    return nil if response.body.blank?

    JSON.parse(response.body)
  end

  private

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
