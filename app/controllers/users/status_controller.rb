# frozen_string_literal: true

class Users::StatusController < ApplicationController
  include MunicipalityAuthorization
  before_action :authenticate_user!

  def show # rubocop:disable Metrics/MethodLength
    respond_to do |format|
      format.json do
        return render json: {
          success: true,
          user: current_user,
          applications: current_user.oauth_applications.as_json(
            only: %i[name id created_at],
            methods: %i[uid secret owner_id owner_type]
          ),
          roles: current_user.try(:data_provider).try(:roles),
          data_provider_id: current_user.try(:data_provider).try(:id)
        }
      end
    end
  end
end
