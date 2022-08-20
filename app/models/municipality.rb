# frozen_string_literal: true

class Municipality < ApplicationRecord
  validates_uniqueness_of :slug
  validates_uniqueness_of :title

  has_many :users, dependent: :destroy

  after_create :create_admin_user
  after_create :create_mobile_app_user


  store :settings,
        accessors: [
          :mailjet_api_key, :mailjet_api_secret, :mailjet_default_from,
          :mailer_notify_admin_to,
          :directus_graphql_endpoint, :directus_graphql_access_token,
          :minio_endpoint, :minio_access_key, :minio_secret_key, :minio_bucket, :minio_region,
          :openweathermap_api_key, :openweathermap_lat, :openweathermap_lon,
          :cms_url
        ],
        coder: JSON

  def url
    "http://#{slug}.#{ADMIN_URL}"
  end

  def create_admin_user
    SetupUserService.new(provider_name: "Administrator", email: "admin@smart-village.app", role: 1, municipality_id: self.id, application_name: "Administrator")
  end

  def create_mobile_app_user
    SetupUserService.new(provider_name: "Mobile App", email: "mobile-app@smart-village.app", role: 2, municipality_id: self.id, application_name: "Mobile App (iOS/Android)")
  end
end
