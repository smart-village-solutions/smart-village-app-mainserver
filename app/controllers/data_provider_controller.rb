class DataProviderController < ApplicationController

  layout "doorkeeper/admin"

  before_action :authenticate_user!, except: [:show]
  before_action :init_data_provider, only: [:edit, :update]
  # before_action :doorkeeper_authorize!, only: [:show]

  def show
    # @data_provider = current_resource_owner.try(:data_provider)
    @data_provider = User.first.try(:data_provider)

    respond_to do |format|
      if @data_provider.present?
        format.json { render json: @data_provider, include:
          {
            logo: { only: [:url, :description] },
            address: { only: [:addition, :street, :city, :zip] },
            contact: { only: [:first_name, :last_name, :phone, :fax, :email] },
          },
          only: [:name, :description], root: true }
      else
        format.json { render json: {}.to_json }
      end
    end
  end

  def edit
  end

  def update
    @data_provider.update_attributes(provider_params)
    flash[:notice] = "Data Provider Updated: #{@data_provider.try(:errors).try(:full_messages)}"
    redirect_to action: :edit
  end

  private

    # Find the user that owns the access token
    def current_resource_owner
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

    def provider_params
      params.require(:data_provider).permit(:name, :description,
        address_attributes: [:addition, :city, :street, :zip, :id],
        contact_attributes: [:first_name, :last_name, :phone, :fax, :email, :id],
        logo_attributes: [:url, :description, :id])
    end

    def init_data_provider
      @data_provider = DataProvider
                         .where(provideable_type: "User", provideable_id: current_user.id)
                         .first_or_create
    end
end
