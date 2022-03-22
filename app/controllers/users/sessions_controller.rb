# frozen_string_literal: true

# Overide the Devise SessionController to enable login via json
# and return a json success message
class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token

  # POST /resource/sign_in
  def create
    resource = warden.authenticate!(scope: resource_name, recall: "#{controller_path}#new")
    set_flash_message(:notice, :signed_in) if is_navigational_format?
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
      format.html { respond_with resource, location: after_sign_in_path_for(resource) }
      format.json do
        return render json: {
          success: true,
          user: resource,
          applications: resource.oauth_applications.as_json(
            only: %i[name id created_at],
            methods: %i[uid secret owner_id owner_type]
          ),
          roles: resource.try(:data_provider).try(:roles),
          minio: minio_config
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
