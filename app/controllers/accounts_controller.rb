# frozen_string_literal: true

# Overide the Devise SessionController to enable login via json
# and return a json success message
class AccountsController < ApplicationController
  layout "doorkeeper/admin"

  before_action :authenticate_user!
  before_action :authenticate_admin

  include SortableController

  def authenticate_admin
    render inline: "not allowed", status: 404 unless current_user.admin_role?
  end

  def index
    @users = User
      .sorted_for_params(params)
      .where_email_contains(params[:query])
      .page(params[:page])
  end

  def edit
    @user = User.find(params["id"])
    @user.build_data_provider if @user.data_provider.blank?
    DataResourceSetting::DATA_RESOURCES.each do |data_resource|
      data_resource_settings = @user.data_provider.data_resource_settings.where(
        data_resource_type: data_resource.to_s
      )
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
        @user.oauth_applications.create(
          name: "Zugriff per CMS",
          redirect_uri: "urn:ietf:wg:oauth:2.0:oob",
          confidential: true
        )
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

  # get /accounts/3/batch_defaults?data_resource_type=NewsItem
  def batch_defaults
    @user = User.find(params["id"])
    data_resource_type = params[:data_resource_type]
    system "rake batch_defaults:create DATAPROVIDER_ID=#{@user.data_provider_id} DATA_RESOURCE_TYPE=#{data_resource_type}"
    flash[:notice] = "Batch Action wurde gestartet für den Typ #{data_resource_type}"
    respond_to do |format|
      format.html { redirect_to action: :edit }
    end
  end

  def account_params
    values = params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :role,
      data_provider_attributes: [
        :id,
        :name,
        :data_type,
        :description,
        :notice,
        :role_point_of_interest,
        :role_tour,
        :role_news_item,
        :role_event_record,
        :role_push_notification,
        :role_lunch,
        :role_waste_calendar,
        :role_job,
        :role_offer,
        :role_construction_site,
        :role_survey,
        :role_encounter_support,
        :role_static_contents,
        :role_tour_stops,
        :role_deadlines,
        :role_noticeboard,
        :role_defect_report,
        logo_attributes: %i[
          id
          url
          description
        ],
        address_attributes: %i[
          id
          street
          addition
          zip
          city
        ],
        contact_attributes: %i[
          id
          first_name
          last_name
          phone
          fax
          email
        ],
        data_resource_settings_attributes: [
          :id,
          :data_resource_type,
          :display_only_summary,
          :always_recreate_on_import,
          :data_provider_id,
          :only_summary_link_text,
          :convert_media_urls_to_external_storage,
          :cleanup_old_records,
          :post_to_facebook,
          :facebook_page_id,
          :facebook_page_access_token,
          default_category_ids: []
        ]
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
