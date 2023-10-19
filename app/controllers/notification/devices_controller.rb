# frozen_string_literal: true

class Notification::DevicesController < ApplicationController
  layout "doorkeeper/admin"

  include SortableController

  skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]

  before_action :auth_user_or_doorkeeper, only: [:create, :update, :destroy]
  before_action :authenticate_user!, except: [:create, :update, :destroy]
  before_action :authenticate_admin, except: [:create, :update, :destroy]
  before_action :set_notification_device, only: [:show, :edit, :update, :destroy, :send_notification]

  def authenticate_admin
    render inline: "not allowed", status: 405 unless current_user.admin_role?
  end

  def auth_user_or_doorkeeper
    raise "unauthorized" if current_user.present? && !current_user.admin_role?

    doorkeeper_authorize! if current_user.blank?
  end

  def send_notifications
    options = params.permit![:notification]
    PushNotification.delay.send_notifications(options) if options[:title].present?

    respond_to do |format|
      format.html { redirect_to notification_devices_url, notice: "Push Notifications gesendet" }
    end
  end

  def send_notification
    options = params.permit![:notification]
    PushNotification.delay.send_notification(@notification_device, options) if options[:title].present?

    respond_to do |format|
      format.html { redirect_to notification_device_path(@notification_device), notice: "Push Notification gesendet" }
    end
  end

  # GET /notification/devices
  # GET /notification/devices.json
  def index
    @notification_devices = Notification::Device
      .sorted_for_params(params)
      .where_token_contains(params[:query])
      .page(params[:page])

    @push_logs = RedisAdapter.get_push_logs
  end

  # GET /notification/devices/1
  # GET /notification/devices/1.json
  def show
    @push_logs = RedisAdapter.get_push_logs_for_device(@notification_device.token)
  end

  # GET /notification/devices/new
  def new
    @notification_device = Notification::Device.new
  end

  # GET /notification/devices/1/edit
  def edit
    @push_logs = RedisAdapter.get_push_logs_for_device(@notification_device.token)
  end

  # POST /notification/devices
  # POST /notification/devices.json
  def create
    @notification_device = Notification::Device.new(notification_device_params)

    respond_to do |format|
      begin
        if @notification_device.save
          format.html { redirect_to @notification_device, notice: "Device was successfully created." }
          format.json { render :show, status: :created, location: @notification_device }
        else
          format.html { render :new }
          format.json { render json: @notification_device.errors, status: :unprocessable_entity }
        end
      rescue ActiveRecord::RecordNotUnique
        format.html { render :new }
        format.json { render json: @notification_device.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notification/devices/1
  # PATCH/PUT /notification/devices/1.json
  def update
    respond_to do |format|
      if @notification_device.present? && @notification_device.update(notification_device_params)
        format.html { redirect_to @notification_device, notice: "Device was successfully updated." }
        format.json { render :show, status: :ok, location: @notification_device }
      else
        format.html { render :edit }
        format.json { render json: @notification_device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notification/devices/1
  # DELETE /notification/devices/1.json
  def destroy
    respond_to do |format|
      if @notification_device.present?
        Notification::Device.where(token: @notification_device.token).destroy_all
        format.html { redirect_to notification_devices_url, notice: "Device was successfully destroyed." }
        format.json { head :no_content }
      else
        format.html { redirect_to notification_devices_url, notice: "Device was successfully destroyed." }
        format.json { render json: nil, status: 404 }
      end
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_notification_device
      token = notification_device_params[:token] if params[:notification_device].present?
      @notification_device = Notification::Device.find_by(token: token) and return if token.present?
      @notification_device = Notification::Device.find(params[:id]) if params[:id].present?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notification_device_params
      params.require(:notification_device).permit(
        :token, :device_type, exclude_data_provider_ids: [], exclude_mowas_regional_keys: []
      )
    end
end
