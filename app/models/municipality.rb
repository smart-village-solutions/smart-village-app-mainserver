# frozen_string_literal: true

class Municipality < ApplicationRecord
  validates_uniqueness_of :slug
  validates_uniqueness_of :title

  after_create :create_admin_user
  has_many :users

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
    user_password = SecureRandom.alphanumeric
    username = "admin@smart-village.app"
    user = User.create(email: username, password: user_password, password_confirmation: user_password, role: 1, municipality: self)

    OnePasswordService.setup(municipality_id: self.id, password: user_password, username: username) if user.valid? && Rails.env.production?
  end
end
