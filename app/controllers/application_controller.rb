# frozen_string_literal: true

class ApplicationController < ActionController::Base
  layout "doorkeeper/application"

  def generate_204
    head(:no_content)
  end

  def not_found_404
    head(:not_found)
  end
end
