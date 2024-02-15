# frozen_string_literal: true

class HealthCheckController < ActionController::Base
  skip_before_action :verify_authenticity_token

  # get "health-check" => "health_check#show"
  def show
    respond_to do |format|
      format.text { render inline: "OK" }
      format.html { render inline: "OK" }
    end
  end
end
