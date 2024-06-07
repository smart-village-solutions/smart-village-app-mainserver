# frozen_string_literal: true

# Override the Devise SessionController to enable login via json
# and return a json success message
class Members::SessionsController < Devise::SessionsController # rubocop:disable Metrics/ClassLength
  include MunicipalityAuthorization
  respond_to :json, :html

  skip_before_action :verify_authenticity_token

  def show
    @member = current_member
  end

  # GET /resource/sign_in
  def new # rubocop:disable Metrics/MethodLength
    resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)

    respond_to do |format|
      format.html { super }
      format.json do
        if resource.id
          return render json: {
            success: true,
            member: resource
          }, status: 200
        end

        render json: {
          success: false,
          errors: resource&.errors&.full_messages
        }, status: 401
      end
    end
  end

  # POST /resource/sign_in
  def create # rubocop:disable Metrics/MethodLength,Metrics/CyclomaticComplexity
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
        if @resource.present? && @resource.errors.blank?
          return render json: {
            success: true,
            member: @resource
          }, status: 200
        end

        render json: {
          success: false,
          errors: @resource&.errors&.full_messages
        }, status: 401
      end
    end
  end

  def devise_login
    @resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)
    @resource.authentication_token_created_at = Time.zone.now
    @resource.save # recreates authentication_token after sign in
  end

  def keycloak_login # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    keycloak_service = Keycloak::RealmsService.new(MunicipalityService.municipality_id)
    result = keycloak_service.login_user(member_params)
    return false if result.blank?
    return false if result["error"].present?

    # get member data from keycloak
    keycloak_member_data = keycloak_service.get_keycloak_member_data(result["access_token"])

    # find or create member in mainserver with keycloak_id
    @resource = Member.where(municipality_id: MunicipalityService.municipality_id, keycloak_id: keycloak_member_data["sub"]).first_or_create do |member|
      member_password = SecureRandom.alphanumeric
      member.password = member_password
      member.password_confirmation = member_password
    end

    if keycloak_member_data["email_verified"] && @resource.email != keycloak_member_data["email"]
      @resource.update_columns(email: keycloak_member_data["email"])
    end
    @resource.update_keycloak_tokens(keycloak_tokens: result, access_token: result["access_token"])

    sign_in(resource_name, @resource)
    @resource.authentication_token_created_at = Time.zone.now
    @resource.save # recreates authentication_token after sign in
  end

  def key_and_secret_login # rubocop:disable Metrics/MethodLength
    return false if validate_key_and_secret == :error

    @resource = Member.where(
      municipality_id: MunicipalityService.municipality_id,
      email: member_email_by_key(member_params[:key])
    ).first_or_create do |member|
      member_password = SecureRandom.alphanumeric
      member.municipality_id = MunicipalityService.municipality_id
      member.password = member_password
      member.password_confirmation = member_password
    end
    sign_in(resource_name, @resource)
    @resource.authentication_token_created_at = Time.zone.now
    @resource.save # recreates authentication_token after sign in
  end

  def login_type
    return :key_and_secret if member_params[:key].present? && member_params[:secret].present?

    :keycloak
  end

  def member_params
    params.permit![:member]
  end

  # TODO: Auslagern in Keycloak oder Service
  def validate_key_and_secret # rubocop:disable Metrics/MethodLength
    uri = MunicipalityService.settings["member_auth_key_and_secret_url"]
    return :error if uri.blank?

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

    # truncate and sanitized key for email
    hash_email_part = "#{MunicipalityService.municipality_id}-ksa-#{key}"
    hash_email_part = Digest::SHA256.hexdigest(hash_email_part)

    # make a default_email from sanitized_key
    "#{hash_email_part}@smart-village.app"
  end
end
