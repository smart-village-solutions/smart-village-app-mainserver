# Mögliche GEMS für die Entwicklung:
# https://github.com/ccrockett/omniauth-keycloak
# https://github.com/looorent/keycloak-api-rails
# https://www.keycloak.org/docs-api/22.0.5/rest-api/index.html

# https://keycloak.smart-village.app/realms/sva-saas/
# https://keycloak.smart-village.app/realms/sva-saas/account/#/
# https://keycloak.smart-village.app/realms/sva-saas/protocol/openid-connect/auth?client_id=account-console&redirect_uri=https%3A%2F%2Fkeycloak.smart-village.app%2Frealms%2FSVA-SaaS%2Faccount%2F%23%2Fsecurity%2Fdevice-activity&state=8684b22e-d037-42ea-bc0d-019633b3c001&response_mode=fragment&response_type=code&scope=openid&nonce=d580c775-6dc2-4b21-83a9-d28c8c85c428&code_challenge=x6Vx7qzwsABR5rVdVxZs6AOasRIRnLlN5gcj8BQeFb0&code_challenge_method=S256

class Keycloak::RealmsService
  attr_accessor :realm, :uri, :master_token_path, :admin_username, :admin_password, :client_id, :client_secret, :municipality_id

  # Konfiguration ist hier zu finden:
  # https://keycloak.smart-village.app/realms/master/.well-known/openid-configuration
  def initialize(realm, municipality_id, client_id = nil, client_secret = nil)
    @realm = realm
    @client_id = client_id
    @client_secret = client_secret
    @municipality_id = municipality_id
    @uri = "https://keycloak.smart-village.app"
    @master_token_path = "/realms/master/protocol/openid-connect/token"
    @admin_username = "it+keycloak@tpwd.de"
    @admin_password = "Ffa97RLnZdZxq7hQQKtEKMh8F6UPPzZB"
  end

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
      @resource = Member.where(municipality_id: municipality_id, email: member_params[:email]).first_or_create do |member|
        member_password = SecureRandom.alphanumeric
        member.municipality_id = municipality_id
        member.password = member_password
        member.password_confirmation = member_password
      end
      return { status: "created" }
    end

    JSON.parse(result.body)
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
