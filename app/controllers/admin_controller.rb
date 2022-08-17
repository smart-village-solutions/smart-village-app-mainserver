# frozen_string_literal: true

class AdminController < ActionController::Base
  layout "application"

  def generate_204
    head(:no_content)
  end

end
