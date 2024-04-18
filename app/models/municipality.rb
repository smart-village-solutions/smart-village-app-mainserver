# frozen_string_literal: true

class Municipality < ApplicationRecord # rubocop:disable Metrics/ClassLength
  validates_uniqueness_of :slug
  validates_uniqueness_of :title

  has_many :users, dependent: :destroy

  before_create :setup_defaults
  after_create :create_admin_user
  after_create :create_mobile_app_user
  after_create :create_mowas_user
  after_create :create_minio_bucket
  # Erstmal deaktiviert, da wir bereits genug Uptime Robot Monitore haben die auf den gleichen SaaS Service zeigen
  # after_create :create_uptime_robot_monitor
  after_create :create_category_and_static_content

  MEMBER_AUTH_TYPES = ["keycloak", "key_and_secret"]

  store :settings,
        accessors: [
          :mailer_type, :mailjet_api_key, :mailjet_api_secret,
          :mailer_notify_admin_to, :mailjet_default_from,
          :smtp_address, :smtp_port, :smtp_domain, :smtp_user_name, :smtp_password,
          :smtp_authentication, :smtp_enable_starttls_auto, :smtp_ssl,
          :directus_graphql_endpoint, :directus_graphql_access_token,
          :minio_endpoint, :minio_access_key, :minio_secret_key, :minio_bucket, :minio_region,
          :openweathermap_api_key, :openweathermap_lat, :openweathermap_lon,
          :cms_url,
          :rollbar_access_token,
          :redis_host, :redis_namespace,
          :uptime_robot_api_key, :uptime_robot_alert_contacts,
          :member_auth_types,
          :member_keycloak_url, :member_keycloak_realm, :member_keycloak_client_id, :member_keycloak_client_secret,
          :member_keycloak_admin_username, :member_keycloak_admin_password
        ],
        coder: JSON

  def url
    "https://#{slug}.#{ADMIN_URL}"
  end

  def cms_url
    "https://#{slug}.#{CMS_URL}"
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
  def setup_defaults # rubocop:disable all
    # Member Auth Settings
    self.member_auth_types = Municipality::MEMBER_AUTH_TYPES if self.member_auth_types.nil?
    self.member_keycloak_url = Settings.member_auth[:keycloak_url] if self.member_keycloak_url.nil?
    self.member_keycloak_realm = slug if self.member_keycloak_realm.nil?
    self.member_keycloak_client_id = Settings.member_auth[:keycloak_client_id] if self.member_keycloak_client_id.nil?
    self.member_keycloak_client_secret = Settings.member_auth[:keycloak_client_secret] if self.member_keycloak_client_secret.nil?
    self.member_keycloak_admin_username = Settings.member_auth[:keycloak_admin_username] if self.member_keycloak_admin_username.nil?
    self.member_keycloak_admin_password = Settings.member_auth[:keycloak_admin_password] if self.member_keycloak_admin_password.nil?

    # Uptime Robot
    self.uptime_robot_api_key = Settings.uptime_robot[:api_key] if self.uptime_robot_api_key.nil?
    self.uptime_robot_alert_contacts = Settings.uptime_robot[:alert_contacts] if self.uptime_robot_alert_contacts.nil?

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
    SetupUserService.new(
      provider_name: "Administrator",
      email: "admin@smart-village.app",
      role: 1,
      municipality_id: self.id,
      application_name: "Administrator",
      data_provider_roles: {
        role_point_of_interest: true,
        role_tour: true,
        role_news_item: true,
        role_event_record: true,
        role_push_notification: true,
        role_lunch: true,
        role_waste_calendar: true,
        role_job: true,
        role_offer: true,
        role_construction_site: true,
        role_survey: true,
        role_encounter_support: true,
        role_static_contents: true,
        role_tour_stops: true
      }
    )
  end

  def create_mobile_app_user
    SetupUserService.new(
      provider_name: "Mobile App",
      email: "mobile-app@smart-village.app",
      role: 2,
      municipality_id: self.id,
      application_name: "Mobile App (iOS/Android)"
    )
  end

  def create_mowas_user
    SetupUserService.new(
      provider_name: "Warnsystem des Bundes",
      description: "Zur automatischen Erstellung von Warnungen durch das MoWaS (Modulares Warnsystem des Bundes) inkl. Push-Notification",
      logo_url: "https://fileserver.smart-village.app/fileserver/partner/mowas-banner.png",
      email: "mowas@smart-village.app",
      role: 0,
      municipality_id: self.id,
      application_name: "Zugriff per CMS",
      data_provider_roles: {
        role_news_item: true,
        role_push_notification: true,
      }
    )
  end

  def create_minio_bucket
    return unless minio_config_valid?

    MinioService.new(
      endpoint: minio_endpoint,
      access_key: minio_access_key,
      secret_key: minio_secret_key,
      region: minio_region
    ).create_bucket(minio_bucket)
  end

  def create_uptime_robot_monitor
    return unless Rails.env.production?

    UptimeRobotService.new(
      api_key: uptime_robot_api_key,
      alert_contacts: uptime_robot_alert_contacts,
      slug: slug
    ).create_monitors
  end

  def create_category_and_static_content
    category = Category.where(name: "Nachrichten", municipality_id: self.id).first_or_create

    StaticContent.create(
      name: "globalSettings",
      content: initial_static_content_data_for_news(category.id),
      data_type: "json",
      municipality_id: self.id
    )
  end

  def initial_static_content_data_for_news(category_id)
    {
      "filter": {
        "news": false,
        "events": true
      },
      "showImageRights": false,
      "sections": {
        "showNews": true,
        "showPointsOfInterestAndTours": true,
        "showEvents": true,
        "headlineNews": "Nachrichten",
        "buttonNews": "Alle Nachrichten anzeigen",
        "categoriesNews": [
          {
            "categoryId": category_id,
            "categoryTitle": "Nachrichten",
            "categoryTitleDetail": "Nachricht",
            "categoryButton": "Alle Nachrichten anzeigen"
          }
        ],
        "headlinePointsOfInterestAndTours": "Touren und Orte",
        "buttonPointsOfInterestAndTours": "Alle Touren und Orte anzeigen",
        "headlineEvents": "Veranstaltungen",
        "buttonEvents": "Alle Veranstaltungen anzeigen",
        "headlineService": "Service",
        "headlineAbout": "Über die App"
      },
      "settings": {
        "pushNotifications": true,
        "feedbackFooter": true,
        "matomo": false,
        "locationService": false,
        "onboarding": false
      },
      "widgets": [
        "weather"
      ]
    }.to_json
  end
end

# == Schema Information
#
# Table name: municipalities
#
#  id         :bigint           not null, primary key
#  slug       :string(255)
#  title      :string(255)
#  settings   :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
