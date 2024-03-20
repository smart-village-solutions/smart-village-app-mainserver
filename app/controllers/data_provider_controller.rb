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
            logo: { only: [:url, :description] },
            address: { only: [:addition, :street, :city, :zip] },
            contact: { only: [:first_name, :last_name, :phone, :fax, :email] }
          },
          only: [:name, :description, :notice],
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
      format.json { render json: @data_provider, include: [:logo, :address, :contact, :external_service_credential]}
      format.html
    end
  end

  # def update
  #   if @data_provider.update(provider_params)
  #     flash[:notice] = "Data Provider Updated successfully."
  #     current_user.data_provider = @data_provider unless current_user.data_provider == @data_provider
  #     current_user.save if current_user.changed?
  #   else
  #     flash.now[:alert] = @data_provider.errors.full_messages.to_sentence
  #   end

  #   respond_to do |format|
  #     format.json { render json: @data_provider, status: :ok, include: [:logo, :address, :contact] }
  #     format.html { redirect_to action: :edit }
  #   end
  # rescue => e
  #   flash.now[:alert] = "An error occurred: #{e.message}"
  #   render :edit
  # end

  def update
    @data_provider.update(provider_params)
    current_user.data_provider = @data_provider
    current_user.data_provider.save

    flash[:notice] = "Data Provider Updated: #{@data_provider.try(:errors).try(:full_messages)}"
    respond_to do |format|
      format.json { render json: @data_provider, include: [:logo, :address, :contact, :external_service_credential]}
      format.html { redirect_to action: :edit }
    end
  end

  private

    # Find the user that owns the access token
    def current_resource_owner
      User.find_by(id: doorkeeper_token.try(:application).try(:owner_id)) if doorkeeper_token
    end

    def provider_params
      params.require(:data_provider).permit(:name, :description, :notice,
        address_attributes: [:addition, :city, :street, :zip, :id],
        contact_attributes: [:first_name, :last_name, :phone, :fax, :email, :id],
        logo_attributes: [:url, :description, :id],
        external_service_credential_attributes: [:id, :client_key, :client_secret, :external_service_id])
    end

    def init_data_provider
      @data_provider = current_user.data_provider.presence || current_user.build_data_provider
    end
end
