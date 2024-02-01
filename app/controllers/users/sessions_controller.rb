# frozen_string_literal: true

# Overide the Devise SessionController to enable login via json
# and return a json success message
class Users::SessionsController < Devise::SessionsController
  include MunicipalityAuthorization
  respond_to :json, :html

  skip_before_action :verify_authenticity_token

  # GET /resource/sign_in
  def new # rubocop:disable Metrics/MethodLength
    resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)

    respond_to do |format|
      format.html { super }
      format.json do
        return render json: {
          success: resource.id ? false : true,
          user: resource.id ? resource : nil,
          applications: resource.oauth_applications.as_json(
            only: %i[name id created_at],
            methods: %i[uid secret owner_id owner_type]
          ),
          roles: resource.try(:data_provider).try(:roles),
          minio: resource.id ? minio_config : nil
        }
      end
    end
  end

  # POST /resource/sign_in
  def create # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)
    resource.save # recreates authentication_token after sign in

    # Ein Login zum Graphiql Interface ist nur mit einer
    # OAuth-Application möglich.
    if resource.oauth_applications.any?
      graphql_access_token = Doorkeeper::AccessToken.create(
        application: resource.oauth_applications.first,
        resource_owner_id: resource.id,
        expires_in: 1.day
      ).token
      cookies["_graphql_token"] = graphql_access_token
    end

    respond_to do |format|
      format.html { super }
      format.json do
        render json: {
          success: true,
          user: resource,
          applications: resource.oauth_applications.as_json(
            only: %i[name id created_at],
            methods: %i[uid secret owner_id owner_type]
          ),
          roles: resource.try(:data_provider).try(:roles),
          minio: minio_config,
          data_provider_id: resource.try(:data_provider).try(:id)
        }
      end
    end
  end

  private

  def minio_config
    {
      endpoint: @current_municipality.minio_endpoint,
      region: @current_municipality.minio_region,
      bucket: @current_municipality.minio_bucket,
      access_key_id: @current_municipality.minio_access_key,
      secret_access_key: @current_municipality.minio_secret_key
    }
  end
end
