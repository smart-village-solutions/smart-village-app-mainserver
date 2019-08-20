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
    respond_to do |format|
      format.html { respond_with resource, location: after_sign_in_path_for(resource) }
      format.json do
        return render json: {
          success: true,
          user: resource,
          applications: resource.oauth_applications
        }
      end
    end
  end
end
