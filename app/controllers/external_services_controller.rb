# frozen_string_literal: true

# Controller for adding the external services by admins
class ExternalServicesController < ApplicationController
  layout "doorkeeper/admin"

  before_action :authenticate_user!
  before_action :authenticate_admin_role
  before_action :set_external_service, only: %i[show edit update destroy]

  def index
    @external_services = ExternalService.all
  end

  def show
  end

  def new
    @external_service = ExternalService.new
  end

  def edit
  end

  def create
    @external_service = ExternalService.new(external_service_params)

    if @external_service.save
      redirect_to external_services_path, notice: "External service was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @external_service.assign_attributes(external_service_params.except(:resource_config))
    @external_service.resource_config = JSON.parse(external_service_params[:resource_config])

    if @external_service.save
      redirect_to external_services_path, notice: "External service was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @external_service.data_providers.any?
      data_provider_names = @external_service.data_providers.pluck(:name)
      redirect_to external_services_url, alert: "Failed to destroy external service: Can't delete External Service as it is associated with DataProviders: #{data_provider_names}."
    else
      @external_service.destroy
      redirect_to external_services_url, notice: "External service was successfully destroyed."
    end
  end

  private

    def authenticate_admin_role
      redirect_to root_path, alert: "Not allowed" unless current_user.admin_role?
    end

    def set_external_service
      @external_service = ExternalService.find(params[:id])
    end

    def external_service_params
      params.require(:external_service).permit(:name, :base_uri, :resource_config)
    end
end
