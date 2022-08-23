# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include MunicipalityAuthorization

  layout "doorkeeper/application"

  def generate_204
    head(:no_content)
  end
end
