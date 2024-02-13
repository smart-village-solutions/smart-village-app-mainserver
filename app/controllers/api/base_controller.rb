# frozen_string_literal: true

class Api::BaseController < ApplicationController
  before_action :doorkeeper_authorize!
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user_role

  def render_not_found
    render json: { errors: "Resource Not Found" }, status: :not_found
  end

  def render_unauthorized(error)
    render json: { errors: error }, status: :unauthorized
  end

  def authenticate_user_role
    render_unauthorized("Unauthorized") unless current_user.account_manager?
  end

  def current_user
    @current_user ||= User.find_by(id: doorkeeper_token.try(:application).try(:owner_id)) if doorkeeper_token
  end
end
