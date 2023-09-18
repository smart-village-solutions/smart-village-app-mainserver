# frozen_string_literal: true

#
# A Tour is a planned route to walk ride or canoe and which passes through
# the surrounding areas of the Smart Village
#
class Tour < Attraction
  enum means_of_transportation: { bike: 0, canoe: 1, foot: 2 }

  has_many :data_resource_categories, -> { where(data_resource_type: "Tour") }, foreign_key: :data_resource_id
  has_many :categories, through: :data_resource_categories
  has_many :geometry_tour_data, as: :geo_locateable, class_name: "GeoLocation", dependent: :destroy
  has_many :tour_stop_assignments, foreign_key: :tour_id, dependent: :destroy
  has_many :tour_stops, through: :tour_stop_assignments

  accepts_nested_attributes_for :geometry_tour_data, :tour_stops

  def settings
    data_provider.data_resource_settings.where(data_resource_type: "Tour").first.try(:settings)
  end

  def unique_id
    fields = [name, type]

    first_address = addresses.first
    address_keys = %i[street zip city kind]
    address_fields = address_keys.map { |a| first_address.try(:send, a) }

    generate_checksum(fields + address_fields)
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
