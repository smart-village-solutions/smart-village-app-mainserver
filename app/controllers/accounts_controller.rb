# frozen_string_literal: true

# Overide the Devise SessionController to enable login via json
# and return a json success message
class AccountsController < ApplicationController
  layout "doorkeeper/admin"

  skip_before_action :verify_authenticity_token, only: %i[check_rss_feeds]

  before_action :authenticate_user!
  before_action :authenticate_user_role

  include SortableController

  USER_PARAMS = %i[
    email
    password
    password_confirmation
    role
  ].freeze

  DATA_PROVIDER_PARAMS = %i[
    id
    name
    data_type
    description
    notice
    role_point_of_interest
    role_tour
    role_news_item
    role_event_record
    role_push_notification
    role_lunch
    role_waste_calendar
    role_job
    role_offer
    role_construction_site
    role_survey
    role_encounter_support
    role_static_contents
    role_tour_stops
    role_deadlines
    role_noticeboard
    role_voucher
    role_defect_report
    import_feeds
  ].freeze

  ADDRESS_PARAMS = %i[
    id
    street
    addition
    zip
    city
  ].freeze

  CONTACT_PARAMS = %i[
    id
    first_name
    last_name
    phone
    fax
    email
  ].freeze

  LOGO_PARAMS = %i[
    id
    url
    description
  ].freeze

  DATA_RESOURCE_SETTINGS_PARAMS = [
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
    { default_category_ids: [] }
  ].freeze

  EXTERNAL_SERVICE_CREDENTIAL_PARAMS = %i[
    id
    client_key
    client_secret
    external_service_id
  ].freeze

  def authenticate_user_role
    redirect_to edit_data_provider_path and return unless current_user.admin_role?
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
    @user.data_provider.build_external_service_credential if @user.data_provider.external_service_credential.blank?
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

  def check_rss_feeds
    rss_feed_check_result = {}

    params.permit!["import_feeds"].to_h.values.each do |feed|
      feed = transform_hash_values(feed)
      rss_feed_check_result[feed["name"]] = CheckRssFeed.new(feed).call
    end

    render json: rss_feed_check_result, status: :ok
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
    @user.update(account_params)
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

  # rubocop:disable Metrics/MethodLength, Layout/LineLength
  def account_params
    additional_params_keys = params.dig(:user, :data_provider_attributes, :external_service_credential_attributes, :additional_params)&.keys
    permitted_additional_params = additional_params_keys ? additional_params_keys.map(&:to_sym) : []

    permitted = params.require(:user).permit(
      *USER_PARAMS,
      data_provider_attributes: [
        *DATA_PROVIDER_PARAMS,
        { address_attributes: ADDRESS_PARAMS },
        { contact_attributes: CONTACT_PARAMS },
        { logo_attributes: LOGO_PARAMS },
        { data_resource_settings_attributes: DATA_RESOURCE_SETTINGS_PARAMS },
        { external_service_credential_attributes: [
          *EXTERNAL_SERVICE_CREDENTIAL_PARAMS,
          { additional_params: permitted_additional_params }
        ]}
      ]
    )

    permitted.delete_if { |_key, value| value.blank? }
  end
  # rubocop:enable Metrics/MethodLength, Layout/LineLength

  def destroy
    @user = User.find(params["id"])
    @user.destroy
    flash[:notice] = "Nutzer wurde gelöscht"
    respond_to do |format|
      format.html { redirect_to action: :index }
    end
  end

  private

  def transform_hash_values(hash)
    # wenn hash kein Hash ist, dann abbrechen
    return hash unless hash.is_a?(Hash)
    return nil if hash.blank?

    hash.transform_values do |value|
      if value.is_a?(Hash)
        transform_hash_values(value)
      else
        value == 'true' ? true : value
        value == 'false' ? false : value
      end
    end
  end
end
