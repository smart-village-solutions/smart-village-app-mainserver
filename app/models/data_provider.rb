# frozen_string_literal: true

class DataProvider < ApplicationRecord
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
        ],
        coder: JSON
  enum data_type: { general_importer: 0, business_account: 1 }, _suffix: :role

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

  before_save :parse_role_values

  accepts_nested_attributes_for :address, :contact, :logo, :data_resource_settings

  def parse_role_values
    roles.each do |key, value|
      roles[key] = value == "true" || value == true
    end
  end

  def settings(data_resource)
    return if data_resource_settings.blank?

    data_resource_settings.where(data_resource_type: data_resource).first
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
