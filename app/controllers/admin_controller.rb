# frozen_string_literal: true

class AdminController < ActionController::Base
  layout "application"

  before_action :authenticate_admin!

  def generate_204
    head(:no_content)
  end
end
