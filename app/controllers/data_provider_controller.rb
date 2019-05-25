class DataProviderController < ApplicationController

  layout "doorkeeper/admin"

  before_action :authenticate_user!
  before_action :init_data_provider, only: [:edit, :update]

  def edit
  end

  def update
    @data_provider.update_attributes(provider_params)
    flash[:notice] = "Data Provider Updated"
    redirect_to action: :edit
  end

  private

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
