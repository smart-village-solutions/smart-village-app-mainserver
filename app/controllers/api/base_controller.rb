# frozen_string_literal: true

class Api::BaseController < ApplicationController
  before_action :doorkeeper_authorize!
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user_role
  rescue_from ActionController::ParameterMissing, with: :render_unprocessable_entity
  rescue_from ArgumentError, with: :render_unprocessable_entity
  rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid

  def render_record_invalid(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

  def render_not_found
    render json: { errors: "Resource Not Found" }, status: :not_found
  end

  def render_unauthorized(error = "Unauthorized")
    render json: { errors: error }, status: :unauthorized
  end

  def render_unprocessable_entity(exception)
    render json: { errors: exception.message }, status: :unprocessable_entity
  end

  def authenticate_user_role
    render_unauthorized unless current_user&.account_manager_role? || current_user&.admin_role?
  end

  def current_user
    @current_user ||= User.find_by(id: doorkeeper_token.try(:application).try(:owner_id))
  end
end
