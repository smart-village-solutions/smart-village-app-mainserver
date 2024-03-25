# frozen_string_literal: true

class ExternalServices::AuthService
  def initialize(user)
    @user = user
    load_credentials
  end

  def obtain_access_token
    uri = URI("#{@base_uri}/oauth/token")
    response = Net::HTTP.post_form(uri, request_params)
    response_body = JSON.parse(response.body, symbolize_names: true)

    return unless response.is_a?(Net::HTTPSuccess)

    {
      access_token: response_body[:access_token],
      expires_at: Time.now + response_body[:expires_in].to_i,
      token_type: response_body[:token_type]
    }
  end

  private

    def request_params
      {
        "grant_type" => "client_credentials",
        "client_id" => @client_key,
        "client_secret" => @client_secret
      }
    end

    def load_credentials
      credentials = @user.data_provider.external_service_credential

      @base_uri = credentials.external_service.base_uri
      @client_key = credentials.client_key
      @client_secret = credentials.client_secret
    end
end
