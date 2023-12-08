# Mögliche GEMS für die Entwicklung:
# https://github.com/ccrockett/omniauth-keycloak
# https://github.com/looorent/keycloak-api-rails
# https://www.keycloak.org/docs-api/22.0.5/rest-api/index.html

class Keycloak::RealmsService
  attr_accessor :realm, :uri, :master_token_path, :admin_username, :admin_password

  # Konfiguration ist hier zu finden:
  # https://keycloak.smart-village.app/realms/master/.well-known/openid-configuration
  def initialize(realm)
    @realm = realm
    @uri = "https://keycloak.smart-village.app"
    @master_token_path = "/realms/master/protocol/openid-connect/token"
    @admin_username = "it+keycloak@tpwd.de"
    @admin_password = "Ffa97RLnZdZxq7hQQKtEKMh8F6UPPzZB"
  end

  def index
    token_params = token_from_keycloak
    auth_headers = { "Authorization": "Bearer #{token_params["access_token"]}"}
    request = ApiRequestService.new([uri,"/admin/realms"].join, nil, nil, nil, auth_headers)
    result = request.get_request
    JSON.parse(result.body) if result.code == "200"
  end

  def create
  end

  def update
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
      request = ApiRequestService.new([@uri, @master_token_path].join, nil, nil, auth_params, auth_headers)
      result = request.form_post_request

      JSON.parse(result.body) if result.code == "200"
    end
end
