# frozen_string_literal: true

#
# All locations which are interesting and attractive for the public in the
# smart village and the surrounding area
#
class PointOfInterest < Attraction
  has_many :data_resource_categories, -> { where(data_resource_type: "PointOfInterest") }, foreign_key: :data_resource_id
  has_many :categories, through: :data_resource_categories
  has_many :opening_hours, as: :openingable, dependent: :destroy
  has_many :price_informations, as: :priceable, class_name: "Price", dependent: :destroy
  has_many :lunches, dependent: :destroy

  accepts_nested_attributes_for :price_informations, :opening_hours, :lunches

  def settings
    data_provider.data_resource_settings.where(data_resource_type: "PointOfInterest").first.try(:settings)
  end

  def unique_id
    fields = [name, type]

    first_address = addresses.first
    address_keys = %i[street zip city kind]
    address_fields = address_keys.map { |a| first_address.try(:send, a) }

    # add opening hours to checksum for point of interests
    opening_hour_fields = []
    if opening_hours.present? && opening_hours.any?
      opening_hour_keys = %i[weekday date_from date_to time_from time_to open description]
      opening_hours.map do |opening_hour|
        opening_hour_fields << opening_hour_keys.map { |oh| opening_hour.try(:send, oh) }
      end
    end

    generate_checksum(fields + address_fields + opening_hour_fields.flatten)
  end

  # get travel times for a specific date
  #
  # @param [String] date "2023-09-18T12:00"
  def gtfs_travel_times(date:, sort_by: "arrival_time", sort_order: "asc")
    current_travel_times = PublicTransportation::TravelTime.new(
      date: date,
      external_id: external_id,
      data_provider_id: data_provider_id
    ).travel_times

    return [] if current_travel_times.blank?

    current_travel_times.sort_by! { |tt| tt[sort_by.to_sym] }
    current_travel_times.reverse! if sort_order == "desc"

    current_travel_times
  end

  def has_travel_times?
    payload.present? && payload["has_travel_times"].present?
  end
end

# == Schema Information
#
# Table name: attractions
#
#  id                      :bigint           not null, primary key
#  external_id             :string(255)
#  name                    :string(255)
#  description             :text(65535)
#  mobile_description      :text(65535)
#  active                  :boolean          default(TRUE)
#  length_km               :integer
#  means_of_transportation :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  type                    :string(255)      default("PointOfInterest"), not null
#  data_provider_id        :integer
#  visible                 :boolean          default(TRUE)
#  payload                 :text(65535)
#
