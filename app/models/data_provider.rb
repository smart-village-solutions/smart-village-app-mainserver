# frozen_string_literal: true

class DataProvider < ApplicationRecord
  include MunicipalityScope

  store :roles,
        accessors: %i[
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
          role_defect_report
          role_voucher
        ],
        coder: JSON
  enum data_type: { general_importer: 0, business_account: 1 }, _suffix: :role

  belongs_to :municipality
  has_many :data_resource_settings, class_name: "DataResourceSetting"
  has_many :news_items
  has_many :generic_items
  has_many :tours
  has_many :point_of_interests
  has_many :event_records
  has_one :user
  has_one :address, as: :addressable
  has_one :contact, as: :contactable
  has_one :logo, as: :web_urlable, class_name: "WebUrl"
  has_one :external_service_credential, dependent: :destroy
  has_one :external_service, through: :external_service_credential

  before_save :parse_role_values

  accepts_nested_attributes_for :address, :contact, :logo, :data_resource_settings, :external_service_credential

  def parse_role_values
    roles.each do |key, value|
      roles[key] = value == "true" || value == true
    end
  end

  def settings(data_resource)
    return if data_resource_settings.blank?

    data_resource_settings.where(data_resource_type: data_resource).first
  end

  def import_feeds_json
    return [] if import_feeds.blank?

    JSON.parse(import_feeds)
  end

  def import_auth_credentials
    user = User.unscoped.where(municipality_id: municipality.id, data_provider_id: id).first

    return nil if user.blank?
    oauth_app = user.oauth_applications.first
    { client_key: oauth_app.uid, client_secret: oauth_app.plaintext_secret, municipality_slug: municipality.slug }
  end
end

# == Schema Information
#
# Table name: data_providers
#
#  id              :bigint           not null, primary key
#  name            :string(255)
#  description     :text(65535)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  always_recreate :text(65535)
#  roles           :text(65535)
#  data_type       :integer          default("general_importer")
#  notice          :text(65535)
#  import_feeds    :text(16777215)
#
