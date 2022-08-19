# frozen_string_literal: true

class AuthController < ActionController::Base
  layout "doorkeeper/application"

  def generate_204
    head(:no_content)
  end

end
