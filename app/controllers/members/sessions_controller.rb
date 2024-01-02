# frozen_string_literal: true

# Overide the Devise SessionController to enable login via json
# and return a json success message
class Members::SessionsController < Devise::SessionsController
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
          member: resource.id ? resource : nil
        }
      end
    end
  end

  # POST /resource/sign_in
  def create # rubocop:disable Metrics/MethodLength
    case login_type
    when :devise
      devise_login
    when :keycloak
      keycloak_login
    when :key_and_secret
      key_and_secret_login
    end

    respond_to do |format|
      format.html { super }
      format.json do
        render json: {
          success: @resource.present?,
          member: @resource
        }
      end
    end
  end

  def devise_login
    @resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)
    @resource.save # recreates authentication_token after sign in
  end

  def keycloak_login
    return false
  end

  def key_and_secret_login
    return false if validate_key_and_secret == :error

    @resource = Member.where(email: member_email_by_key(member_params[:key])).first_or_create do |member|
      member_password = SecureRandom.alphanumeric
      member.municipality_id = MunicipalityService.municipality_id
      member.password = member_password
      member.password_confirmation = member_password
    end
    sign_in(resource_name, @resource)
    @resource.save # recreates authentication_token after sign in
  end

  def login_type
    return :key_and_secret if member_params[:key].present? && member_params[:secret].present?

    :keycloak
  end

  def member_params
    params.permit![:member]
  end

  # todo: Auslagern in Keycloak oder Service
  def validate_key_and_secret # rubocop:disable Metrics/MethodLength
    uri = "https://node-red.bad-belzig.smart-village.app/saas/auth/sign_in"
    data = {
      key: member_params[:key],
      secret: member_params[:secret],
      municipality_id: MunicipalityService.municipality_id
    }
    request_service = ApiRequestService.new(uri, nil, nil, data)
    result = request_service.post_request

    return :error if result.code != "200"
    return :error if JSON.parse(result.body)["status"] != "success"

    :success
  end

  def member_email_by_key(key)
    # check if key is already an email
    return "key-secret-account-#{key}" if key.include?("@")

    # make a default_email from key
    "#{MunicipalityService.municipality_id}-key-secret-account-#{key}@smart-village.app"
  end
end
