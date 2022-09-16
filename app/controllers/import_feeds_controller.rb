# frozen_string_literal: true

class ImportFeedsController < AdminController
  layout "doorkeeper/admin"

  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_admin!
  before_action :authenticate_admin_token

  def authenticate_admin_token
    render json: { status: "unauthorized" } and return unless params[:auth_token] == Rails.application.credentials[:api_admin_token]
  end

  # GET /static_contents
  # GET /static_contents.json
  def index
    @data_providers = DataProvider.unscoped.where("length(import_feeds) > 10")
    respond_to do |format|
      format.json do
        return render json: @data_providers.to_json(only: [:id], methods: [:import_feeds_json, :import_auth_credentials])
      end
    end
  end
end
