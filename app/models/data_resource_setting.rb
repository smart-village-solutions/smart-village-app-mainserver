# frozen_string_literal: true

class DataResourceSetting < ApplicationRecord
  DATA_RESOURCES = [Tour, PointOfInterest, NewsItem, EventRecord, GenericItem].freeze

  store :settings,
        accessors: %i[
          display_only_summary
          always_recreate_on_import
          only_summary_link_text
          convert_media_urls_to_external_storage
          default_category_ids
          cleanup_old_records
          post_to_facebook
          facebook_page_id
          facebook_page_access_token
        ],
        coder: JSON

  GLOBAL_SETTINGS_ATTRIBUTES = [
    :filter_category_ids, :use_global_resource, :filter_location_name, :filter_location_region,
    :filter_location_department, :filter_location_district, :filter_location_state, :filter_location_country
  ]
  store :global_settings, coder: JSON

  before_save :cleanup_global_settings
  # maybe we cache the municipality_ids to display somewhere
  after_save :update_municipality_cache

  belongs_to :data_provider

  def has_default_categories?
    return false unless default_category_ids.present?

    default_category_ids.compact.uniq.delete_if(&:blank?).present?
  end

  # Returns the global settings for the current municipality
  def global_settings_for_current_municipality
    return {} if global_settings.blank?
    return {} if MunicipalityService.municipality_id.blank?

    global_settings.fetch("municipality_#{MunicipalityService.municipality_id}", {})
  end

  # define Setter and getter methods for global_settings_attributes,
  # We need custom getter and setter methods, because we store the attributes nested for the current municipality_id
  GLOBAL_SETTINGS_ATTRIBUTES.each do |global_settings_attribute|
    define_method(global_settings_attribute) do
      global_settings_for_current_municipality[global_settings_attribute]
    end

    define_method("#{global_settings_attribute}=") do |value|
      self.global_settings = {} if self.global_settings.blank?
      self.global_settings["municipality_#{MunicipalityService.municipality_id}"] = {} if self.global_settings["municipality_#{MunicipalityService.municipality_id}"].blank?
      self.global_settings["municipality_#{MunicipalityService.municipality_id}"][global_settings_attribute] = value
    end
  end

  private

    def cleanup_global_settings
      self.global_settings = {} if self.global_settings.blank?
      GLOBAL_SETTINGS_ATTRIBUTES.each do |global_settings_attribute|
        self.global_settings["municipality_#{MunicipalityService.municipality_id}"] = {} if self.global_settings["municipality_#{MunicipalityService.municipality_id}"].blank?
        unless global_settings_attribute == :use_global_resource
          self.global_settings["municipality_#{MunicipalityService.municipality_id}"][global_settings_attribute] = [] if self.global_settings["municipality_#{MunicipalityService.municipality_id}"][global_settings_attribute].blank?
          self.global_settings["municipality_#{MunicipalityService.municipality_id}"][global_settings_attribute] = self.global_settings["municipality_#{MunicipalityService.municipality_id}"][global_settings_attribute].delete_if(&:blank?)
        end
      end
    end

    def update_municipality_cache
      municipality = Municipality.find_by(id: MunicipalityService.municipality_id)
      municipality.activated_globals = {} if municipality.activated_globals.blank?
      municipality.activated_globals["municipality_ids"] = []
      municipality.activated_globals["data_provider_ids"] = []
      municipality.save
    end
end

# == Schema Information
#
# Table name: data_resource_settings
#
#  id                 :bigint           not null, primary key
#  data_provider_id   :integer
#  data_resource_type :string(255)
#  settings           :text(16777215)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
