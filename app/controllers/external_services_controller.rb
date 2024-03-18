# frozen_string_literal: true

# Controller for adding the external services by admins
class ExternalServicesController < ApplicationController
  layout "doorkeeper/admin"

  before_action :authenticate_user!
  before_action :authenticate_user_role
  before_action :set_external_service, only: %i[show edit update destroy]

  def authenticate_user_role
    render inline: "not allowed", status: 404 unless current_user.admin_role?
  end

  def index
    @external_services = ExternalService.all
  end

  def show
  end

  def new
    @external_service = ExternalService.new
  end

  def edit; end

  def create
    @external_service = ExternalService.new(external_service_params)

    respond_to do |format|
      if @external_service.save
        format.html { redirect_to external_services_path, notice: "External service was successfully created." }
        format.json { render :show, status: :created, location: @external_service }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @external_service.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @external_service = ExternalService.find(params[:id])

    respond_to do |format|
      if @external_service.update(external_service_params)
        format.html { redirect_to external_services_path, notice: "External service was successfully updated." }
        format.json { render :show, status: :ok, location: @external_service }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @external_service.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @external_service = ExternalService.find(params[:id])
    @external_service.destroy
    respond_to do |format|
      format.html { redirect_to external_services_url, notice: "External service was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_external_service
      @external_service = ExternalService.find(params[:id])
    end

    def external_service_params
      params.require(:external_service).permit(:name, :base_uri, :resource_config)
    end
end
