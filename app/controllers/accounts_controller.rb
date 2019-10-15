# frozen_string_literal: true

# Overide the Devise SessionController to enable login via json
# and return a json success message
class AccountsController < ApplicationController
  layout "doorkeeper/admin"

  before_action :authenticate_user!
  before_action :authenticate_admin

  def authenticate_admin
    render inline: "not allowed", status: 404 unless current_user.admin_role?
  end

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params["id"])
    @user.build_data_provider if @user.data_provider.blank?
    DataResourceSetting::DATA_RESOURCES.each do |data_resource|
      data_resource_settings = @user.data_provider.data_resource_settings.where(data_resource_type: data_resource.to_s)
      data_resource_settings.build if data_resource_settings.blank?
    end
  end

  def new
    @user = User.new
  end

  # POST /resource/sign_in
  def create
    @user = User.new(account_params)


    respond_to do |format|
      if @user.save
        @user.oauth_applications.create(name: "Zugriff per CMS", redirect_uri: "urn:ietf:wg:oauth:2.0:oob", confidential: true)
        flash[:notice] = "Nutzer wurde erstellt"
        format.html { redirect_to action: :edit, id: @user.id }
      else
        format.html { render action: :new }
      end
    end
  end

  # POST /resource/sign_in
  def update
    @user = User.find(params["id"])
    @user.update_attributes(account_params)
    flash[:notice] = "Nutzer aktualisiert"
    respond_to do |format|
      format.html { redirect_to action: :edit }
    end
  end

  def account_params
    values = params.require(:user).permit(
      :email, :password, :password_confirmation, :role,
      data_provider_attributes: [
        :id, :name, :description,
        :role_point_of_interest, :role_tour, :role_news_item, :role_event_record,
        logo_attributes: [:id, :url, :description],
        address_attributes: [:id, :street, :addition, :zip, :city],
        contact_attributes: [:id, :first_name, :last_name, :phone, :fax, :email],
        data_resource_settings_attributes: [:id, :data_resource_type, :display_only_summary, :always_recreate_on_import, :data_provider_id, :only_summary_link_text]
      ]
    )
    values.delete_if { |_key, value| value.blank? }
  end

  def destroy
    @user = User.find(params["id"])
    @user.destroy
    flash[:notice] = "Nutzer wurde gelöscht"
    respond_to do |format|
      format.html { redirect_to action: :index }
    end
  end
end
