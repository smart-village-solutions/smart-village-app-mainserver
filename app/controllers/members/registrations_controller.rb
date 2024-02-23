# frozen_string_literal: true

# todo: rewrite Error handling to streamline errors of model and keycloak

class Members::RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token
  include MunicipalityAuthorization
  respond_to :json, :html

  MEMBER_EXCEPT_ATTRIBUTES = %i[
    id password password_confirmation key
    secret authentication_token authentication_token_expires_at
    keycloak_id keycloak_access_token keycloak_access_token_expires_at
    keycloak_refresh_token keycloak_refresh_token_expires_at
  ].freeze

  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create # rubocop:disable Metrics/MethodLength,Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    case login_type
    when :devise
      super
    when :keycloak
      member_params_valid, errors = validate_member_params
      if member_params_valid
        keycloak_service = Keycloak::RealmsService.new(MunicipalityService.municipality_id)
        result = keycloak_service.create_user(member_params)
      else
        # Todo: Anything missing here?
      end
    when :key_and_secret
      super
    end

    respond_to do |format|
      format.html { super }
      format.json do
        if member_params_valid && result.present? && result["errorMessage"].blank? && result["errors"].blank?
          return render json: {
            success: true,
            member: result
          }, status: 201
        end

        render json: {
          success: false,
          errors: errors || result["errorMessage"] || result&.errors&.full_messages
        }, status: 403
      end
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update # rubocop:disable Metrics/MethodLength,Metrics/AbcSize,Metrics/CyclomaticComplexity
    case login_type
    when :devise
      super
    when :keycloak
      keycloak_service = Keycloak::RealmsService.new(MunicipalityService.municipality_id)
      @resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
      result = @resource.update(member_update_params.except(*MEMBER_EXCEPT_ATTRIBUTES))
      keycloak_service.update_user(member_params.except(*Member.stored_attributes[:preferences]), @resource) if result && @resource.errors.blank?
    when :key_and_secret
      super
    end

    respond_to do |format|
      format.html { super }
      format.json do
        if result.present? && @resource.errors.blank?
          return render json: {
            success: true,
            member: result
          }, status: 200
        end

        render json: {
          success: false,
          errors: result&.errors&.full_messages
        }, status: 403
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
      params.permit![:member].permit!
    end

    def member_update_params
      preference_accessors = Member.stored_attributes[:preferences]
      allowed_parameters = [] + preference_accessors
      params.permit![:member].permit(*allowed_parameters)
    end

    def validate_member_params
      return [false, "email missing"] if member_params[:email].blank?
      return [false, "password missing"] if member_params[:password].blank?
      return [false, "password confirmation missing"] if member_params[:password_confirmation].blank?

      if member_params[:password] != member_params[:password_confirmation]
        return [false, "password and password confirmation do not match"]
      end

      [true, nil]
    end

    def login_type
      return :key_and_secret if member_params[:key].present? && member_params[:secret].present?

      :keycloak
    end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: Member.stored_attributes[:preferences])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: Member.stored_attributes[:preferences])
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
