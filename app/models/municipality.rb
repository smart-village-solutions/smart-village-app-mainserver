# frozen_string_literal: true

class Municipality < ApplicationRecord
  validates_uniqueness_of :slug
  validates_uniqueness_of :title

  has_many :users, dependent: :destroy

  before_create :setup_defaults
  after_create :create_admin_user
  after_create :create_mobile_app_user

  store :settings,
        accessors: [
          :mailjet_api_key, :mailjet_api_secret, :mailjet_default_from,
          :mailer_notify_admin_to,
          :directus_graphql_endpoint, :directus_graphql_access_token,
          :minio_endpoint, :minio_access_key, :minio_secret_key, :minio_bucket, :minio_region,
          :openweathermap_api_key, :openweathermap_lat, :openweathermap_lon,
          :cms_url,
          :rollbar_access_token,
          :redis_host, :redis_namespace
        ],
        coder: JSON

  def url
    "http://#{slug}.#{ADMIN_URL}"
  end

  def minio_config_valid?
    minio_endpoint.present? &&
      minio_access_key.present? &&
      minio_secret_key.present? &&
      minio_bucket.present? &&
      minio_region.present?
  end

  # Setup defaults from saas/credentials.yml
  #
  # checking for "nil?" and not for "blank?" to enable manual empty values
  def setup_defaults
    # Mailer Settings
    self.mailer_notify_admin_to = Settings.mailer[:notify_admin][:to] if self.mailer_notify_admin_to.nil?
    self.mailjet_api_key = Settings.mailjet[:api_key] if self.mailjet_api_key.nil?
    self.mailjet_api_secret = Settings.mailjet[:secret_key] if self.mailjet_api_secret.nil?
    self.mailjet_default_from = Settings.mailjet[:default_from] if self.mailjet_default_from.nil?

    # Minio Settings
    self.minio_endpoint = Settings.minio[:endpoint] if self.minio_endpoint.nil?
    self.minio_access_key = Settings.minio[:access_key_id] if self.minio_access_key.nil?
    self.minio_secret_key = Settings.minio[:secret_access_key] if self.minio_secret_key.nil?
    self.minio_bucket = self.slug if self.minio_bucket.nil?
    self.minio_region = Settings.minio[:region] if self.minio_region.nil?

    # OpenWeatherMap Settings
    self.openweathermap_api_key = Settings.openweathermap[:api_key] if self.openweathermap_api_key.nil?
    self.openweathermap_lat = Settings.openweathermap[:lat] if self.openweathermap_lat.nil?
    self.openweathermap_lon = Settings.openweathermap[:lon] if self.openweathermap_lon.nil?

    # CMS Settings
    self.cms_url = Settings.cms[:url] if self.cms_url.nil?

    # Directus Settings
    self.directus_graphql_endpoint = Settings.directus[:graphql_endpoint] if self.directus_graphql_endpoint.nil?
    self.directus_graphql_access_token = Settings.directus[:graphql_access_token] if self.directus_graphql_access_token.nil?

    # Rollbar Settings
    self.rollbar_access_token = Settings.rollbar_access_token if self.rollbar_access_token.nil?

    # Redis Settings
    self.redis_host = Settings.redis[:host] if self.redis_host.nil?
    self.redis_namespace = "#{slug}-saas-mainserver" if self.redis_namespace.nil?
  end

  private

  def create_admin_user
    SetupUserService.new(provider_name: "Administrator", email: "admin@smart-village.app", role: 1, municipality_id: self.id, application_name: "Administrator")
  end

  def create_mobile_app_user
    SetupUserService.new(provider_name: "Mobile App", email: "mobile-app@smart-village.app", role: 2, municipality_id: self.id, application_name: "Mobile App (iOS/Android)")
  end
end
