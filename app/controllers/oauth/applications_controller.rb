# frozen_string_literal: true

class Oauth::ApplicationsController < Doorkeeper::ApplicationsController
  before_action :authenticate_user!

  def index
    if current_user.admin_role?
      @applications = Doorkeeper::Application.page(params[:page])
    else
      @applications = current_user.oauth_applications.page(params[:page])
    end
  end

  # only needed if each application must have some owner
  def create
    @application = Doorkeeper::Application.new(application_params)
    @application.owner = current_user if Doorkeeper.configuration.confirm_application_owner?
    if @application.save
      flash[:notice] = I18n.t(:notice, scope: [:doorkeeper, :flash, :applications, :create])
      redirect_to oauth_application_url(@application)
    else
      render :new
    end
  end

  private

    def set_application
      if current_user.admin_role?
        @application = Doorkeeper::Application.find(params[:id])
      else
        @application = current_user.oauth_applications.find(params[:id])
      end
    end

end
