# frozen_string_literal: true

class Users::StatusController < ApplicationController
  before_action :authenticate_user!

  def show
    respond_to do |format|
      format.json do
        return render json: {
          success: true,
          user: current_user,
          applications: current_user.oauth_applications.as_json(
            only: %i[name id created_at],
            methods: %i[uid secret owner_id owner_type]
          ),
          roles: current_user.try(:data_provider).try(:roles)
        }
      end
    end
  end
end
