# frozen_string_literal: true

class Members::StatusController < ApplicationController
  include MunicipalityAuthorization
  before_action :authenticate_member!

  def show
    @member = current_member
    respond_to do |format|
      format.html { render template: "members/status" }
      format.json do
        return render json: {
          success: true,
          member: @member
        }
      end
    end
  end
end
