# frozen_string_literal: true

class Members::RegistrationsController < Devise::RegistrationsController
  MEMBER_EXCEPT_ATTRIBUTES = %i[
    email id password password_confirmation key
    secret authentication_token authentication_token_expires_at
    keycloak_id keycloak_access_token keycloak_access_token_expires_at
    keycloak_refresh_token keycloak_refresh_token_expires_at
  ].freeze
  include MunicipalityAuthorization
  respond_to :json, :html

  skip_before_action :verify_authenticity_token

  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create # rubocop:disable Metrics/MethodLength
    case login_type
    when :devise
      super
    when :keycloak
      member_params_valid, errors = validate_member_params
      if member_params_valid
        keycloak_service = Keycloak::RealmsService.new(MunicipalityService.municipality_id)
        result = keycloak_service.create_user(member_params)
      else
        result = { status: errors }
      end
    when :key_and_secret
      super
    end

    respond_to do |format|
      format.html { super }
      format.json do
        render json: result
      end
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    case login_type
    when :devise
      super
    when :keycloak
      keycloak_service = Keycloak::RealmsService.new(MunicipalityService.municipality_id)
      @resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
      @resource.update(member_params.except(*MEMBER_EXCEPT_ATTRIBUTES))
      result = keycloak_service.update_user(member_params.delete(:email))
    when :key_and_secret
      super
    end

    respond_to do |format|
      format.html { super }
      format.json do
        render json: result
      end
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def member_params
    preference_accessors = Member.stored_attributes[:preferences]
    allowed_parameters = [] + preference_accessors
    params.permit![:member].permit(*allowed_parameters)
  end

  def validate_member_params
    return [false, "email missing"] if member_params[:email].blank?
    return [false, "password missing"] if member_params[:password].blank?
    return [false, "password confirmation missing"] if member_params[:password_confirmation].blank?
    return [false, "password and password confirmation do not match"] if member_params[:password] != member_params[:password_confirmation]

    [true, nil]
  end

  def login_type
    return :key_and_secret if member_params[:key].present? && member_params[:secret].present?

    :keycloak
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
