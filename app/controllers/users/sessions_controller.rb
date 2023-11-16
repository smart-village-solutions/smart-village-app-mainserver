# frozen_string_literal: true

# Overide the Devise SessionController to enable login via json
# and return a json success message
class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token

  # GET /resource/sign_in
  def new
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
  def create
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
        return render json: {
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
    # Settings only exist on releases branch
    if defined?(Settings)
      Settings.config["minio"]
    else
      Rails.application.credentials[:minio]
    end
  end
end
