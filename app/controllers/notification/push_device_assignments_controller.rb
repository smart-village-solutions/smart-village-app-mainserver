# frozen_string_literal: true

class Notification::PushDeviceAssignmentsController < ApplicationController
  layout "doorkeeper/admin"

  skip_before_action :verify_authenticity_token

  before_action :auth_user_or_doorkeeper
  before_action :set_notification_device
  before_action :set_notification_pushes

  def auth_user_or_doorkeeper
    raise "unauthorized" if current_user.present? && !current_user.admin_role?

    doorkeeper_authorize! if current_user.blank?
  end

  # POST /notification/push_device_assignments/add.json
  def add
    @notification_pushes.each do |notification_push|
      Notification::PushDeviceAssignment.create(
        notification_push: notification_push,
        notification_device: @notification_device
      )
    end

    respond_to do |format|
      format.json { head :no_content }
    end
  rescue StandardError
    respond_to do |format|
      format.json { render json: {}, status: :unprocessable_entity }
    end
  end

  # DELETE /notification/push_device_assignments/remove.json
  def remove
    @notification_pushes.each do |notification_push|
      Notification::PushDeviceAssignment.where(
        notification_push: notification_push,
        notification_device: @notification_device
      ).destroy_all
    end

    respond_to do |format|
      format.json { head :no_content }
    end
  rescue StandardError
    respond_to do |format|
      format.json { render json: {}, status: :unprocessable_entity }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_notification_device
      token = push_device_assignment_params[:token]
      @notification_device = Notification::Device.find_by(token: token) if token.present?
    end

    def set_notification_pushes
      notification_pushable_id = push_device_assignment_params[:notification_pushable_id]
      notification_pushable_type = push_device_assignment_params[:notification_pushable_type]
      @notification_pushes = []

      if notification_pushable_id.present? && notification_pushable_type.present?
        @notification_pushes = Notification::Push.where(
          notification_pushable_id: notification_pushable_id,
          notification_pushable_type: notification_pushable_type
        )
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def push_device_assignment_params
      params.require(:notification_push_device_assignment).permit(
        :token, :notification_pushable_id, :notification_pushable_type
      )
    end
end
