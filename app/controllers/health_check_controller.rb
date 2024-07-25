# frozen_string_literal: true

class HealthCheckController < ApplicationController
  skip_before_action :verify_authenticity_token

  # get "health-check"
  def show
    respond_to do |format|
      format.text { render text: "OK" }
    end
  end
end
