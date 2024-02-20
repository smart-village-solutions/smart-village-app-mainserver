# frozen_string_literal: true

class Members::PasswordsController < Devise::PasswordsController
  skip_before_action :verify_authenticity_token
  include MunicipalityAuthorization
  respond_to :json, :html

  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create # rubocop:disable Metrics/MethodLength,Metrics/AbcSize,Metrics/PerceivedComplexity
    case login_type
    when :devise
      super
    when :keycloak
      keycloak_service = Keycloak::RealmsService.new(MunicipalityService.municipality_id)
      keycloak_service.reset_password(params[:member][:email])
    when :key_and_secret
      super
    end

    respond_to do |format|
      format.html { super }
      format.json do
        return render json: {
          success: true,
          errors: nil
        }, status: 200
      end
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  protected

    def login_type
      return :key_and_secret if member_params[:key].present? && member_params[:secret].present?

      :keycloak
    end

    def member_params
      params.permit![:member].permit!
    end

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
