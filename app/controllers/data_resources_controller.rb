# frozen_string_literal: true

class DataResourcesController < ApplicationController
  layout "doorkeeper/admin"

  before_action :authenticate_user!
  before_action :authenticate_user_role

  def authenticate_user_role
    render inline: "not allowed", status: 404 unless current_user.admin_role?
  end

  # GET /data_resources
  def index
  end
end
