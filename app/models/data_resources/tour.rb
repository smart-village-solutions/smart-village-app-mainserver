# frozen_string_literal: true

#
# A Tour is a planned route to walk ride or canoe and which passes through
# the surrounding areas of the Smart Village
#
class Tour < Attraction
  include MeiliSearch::Rails
  include GlobalFilterScope

  enum means_of_transportation: { bike: 0, canoe: 1, foot: 2 }

  has_many :data_resource_categories, -> { where(data_resource_type: "Tour") }, foreign_key: :data_resource_id
  has_many :categories, through: :data_resource_categories
  has_many :geometry_tour_data, as: :geo_locateable, class_name: "GeoLocation", dependent: :destroy
  has_many :tour_stop_assignments, foreign_key: :tour_id, dependent: :destroy
  has_many :tour_stops, through: :tour_stop_assignments
  has_many :announcements, -> { where(generic_itemable_type: "Tour", generic_type: GenericItem::GENERIC_TYPES[:announcement]) },
           foreign_key: :generic_itemable_id,
           class_name: "GenericItem",
           dependent: :destroy

  accepts_nested_attributes_for :geometry_tour_data, :tour_stops

  FILTERABLE_BY_LOCATION = true
  meilisearch sanitize: true, force_utf8_encoding: true, if: :searchable? do
    pagination max_total_hits: MEILISEARCH_MAX_TOTAL_HITS
    searchable_attributes %i[id name description data_provider_id municipality_id]
    filterable_attributes %i[
      data_provider_id municipality_id location_name location_department
      location_district location_state location_country region_name categories
    ]
    sortable_attributes %i[id title created_at name]
    ranking_rules [
      "sort",
      "created_at:desc",
      "words",
      "typo",
      "proximity",
      "attribute",
      "exactness"
    ]
    attribute :id, :name, :description, :data_provider_id, :visible, :active
    attribute :municipality_id do
      data_provider.try(:municipality_id)
    end
    attribute :categories do
      categories.active.map(&:name)
    end
    attribute :location_name do
      location.try(:name)
    end
    attribute :location_department do
      location.try(:department)
    end
    attribute :location_district do
      location.try(:district)
    end
    attribute :location_state do
      location.try(:state)
    end
    attribute :location_country do
      location.try(:country)
    end
    attribute :region_name do
      location.try(:region).try(:name)
    end
  end

  # List of available filters is defined in service DataResourceFilterServices::AttributeService
  def self.available_filters
    %i[category location radius_search saveable active]
  end

  def searchable?
    visible && data_provider.try(:municipality_id).present?
  end

  def settings
    data_provider.data_resource_settings.where(data_resource_type: "Tour").first.try(:settings)
  rescue StandardError
    nil
  end

  def unique_id
    return external_id if external_id.present?

    fields = [name, type]

    first_address = addresses.first
    address_keys = %i[street zip city kind]
    address_fields = address_keys.map { |a| first_address.try(:send, a) }

    generate_checksum(fields + address_fields)
  end

  def compareable_attributes
    except_attributes = ["id", "created_at", "updated_at", "tag_list", "category_id", "region_id", "visible", "addressable_id", "web_urlable_id", "mediaable_id", "contactable_id"]

    list_of_attributes = {}
    list_of_attributes.merge!(attributes.except(*except_attributes))
    list_of_attributes.merge!(categories: categories.map { |category| category.attributes.except(*except_attributes) })
    list_of_attributes.merge!(addresses: addresses.map { |address| address.attributes.except(*except_attributes) })
    list_of_attributes.merge!(web_urls: web_urls.map { |web_url| web_url.attributes.except(*except_attributes) })

    list_of_attributes
  end
end

# == Schema Information
#
# Table name: attractions
#
#  id                         :bigint           not null, primary key
#  external_id                :string(255)
#  name                       :string(255)
#  description                :text(65535)
#  mobile_description         :text(65535)
#  active                     :boolean          default(TRUE)
#  length_km                  :integer
#  means_of_transportation    :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  type                       :string(255)      default("PointOfInterest"), not null
#  data_provider_id           :integer
#  visible                    :boolean          default(TRUE)
#  payload                    :text(65535)
#  push_notifications_sent_at :datetime
#
