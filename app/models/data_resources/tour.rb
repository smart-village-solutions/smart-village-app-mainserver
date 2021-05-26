# frozen_string_literal: true

#
# A Tour is a planned route to walk ride or canoe and which passes through
# the surrounding areas of the Smart Village
#
class Tour < Attraction
  include FilterByRole

  attr_accessor :force_create
  enum means_of_transportation: { bike: 0, canoe: 1, foot: 2 }

  belongs_to :data_provider

  has_many :data_resource_categories, -> { where(data_resource_type: "Tour") }, foreign_key: :data_resource_id
  has_many :categories, through: :data_resource_categories
  has_many :geometry_tour_data, as: :geo_locateable, class_name: "GeoLocation", dependent: :destroy
  has_one :location, as: :locateable, dependent: :destroy

  accepts_nested_attributes_for :geometry_tour_data, :location

  def unique_id
    fields = [name, type]

    first_address = addresses.first
    address_keys = %i[street zip city kind]
    address_fields = address_keys.map { |a| first_address.try(:send, a) }

    generate_checksum(fields + address_fields)
  end

  def settings
    data_provider.data_resource_settings.where(data_resource_type: "Tour").first.try(:settings)
  end

  def content_for_facebook
    {
      message: [name, description].compact.join("\n\n"),
      link: ""
    }
  end
end

# == Schema Information
#
# Table name: attractions
#
#  id                      :bigint           not null, primary key
#  name                    :string(255)
#  description             :text(65535)
#  mobile_description      :string(255)
#  active                  :boolean          default(TRUE)
#  length_km               :integer
#  means_of_transportation :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  type                    :string(255)      default("PointOfInterest"), not null
#  data_provider_id        :integer
#  visible                 :boolean          default(TRUE)
#
