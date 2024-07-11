# frozen_string_literal: true

class DataProviderController < ApplicationController
  layout "doorkeeper/admin"

  before_action :authenticate_user!, except: [:show]
  before_action :init_data_provider, only: [:edit, :update]
  before_action :doorkeeper_authorize!, only: [:show]

  skip_before_action :verify_authenticity_token, only: [:update]

  def show
    @data_provider = current_resource_owner.try(:data_provider)

    respond_to do |format|
      if @data_provider.present?
        format.json { render json: @data_provider, include:
          {
            logo: { only: %i[url description] },
            address: { only: %i[addition street city zip] },
            contact: { only: %i[first_name last_name phone fax email] }
          },
          only: %i[name description notice],
          root: true
        }
      else
        format.json { render json: {}.to_json }
      end
    end
  end

  # Data Provider has one to one relationship with External Service Credential and External Service through External Service Credential
  # So we need to build the External Service Credential if it does not exist
  def edit
    @data_provider.build_external_service_credential unless @data_provider.external_service_credential

    respond_to do |format|
      format.json { render json: @data_provider, include: %i[logo address contact external_service_credential] }
      format.html
    end
  end

  def update
    @data_provider.update(provider_params)
    current_user.data_provider = @data_provider
    current_user.data_provider.save

    flash[:notice] = "Data Provider Updated: #{@data_provider.try(:errors).try(:full_messages)}"
    respond_to do |format|
      format.json { render json: @data_provider, include: %i[logo address contact external_service_credential] }
      format.html { redirect_to action: :edit }
    end
  end

  private

    # Find the user that owns the access token
    def current_resource_owner
      User.find_by(id: doorkeeper_token.try(:application).try(:owner_id)) if doorkeeper_token
    end

    def provider_params
      # Fetch and convert keys from `additional_params` to symbols for safe parameter permitting, or default to an empty array if none are present.
      additional_params_keys = params.dig(:data_provider,
                                          :external_service_credential_attributes,
                                          :additional_params)&.keys
      permitted_additional_params = additional_params_keys ? additional_params_keys.map(&:to_sym) : []

      params.require(:data_provider)
            .permit(
              :name, :description, :notice,
              address_attributes: %i[addition city street zip id],
              contact_attributes: %i[first_name last_name phone fax email id],
              logo_attributes: %i[url description id],
              external_service_credential_attributes: [
                :id, :client_key, :client_secret, :external_service_id,
                { additional_params: permitted_additional_params }
              ]
            )
    end

    def init_data_provider
      @data_provider = current_user.data_provider.presence || current_user.build_data_provider
    end
end
