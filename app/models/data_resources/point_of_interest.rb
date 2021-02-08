# frozen_string_literal: true

#
# All locations which are interesting and attractive for the public in the
# smart village and the surrounding area
#
class PointOfInterest < Attraction
  include FilterByRole

  attr_accessor :force_create

  belongs_to :data_provider

  has_many :data_resource_categories, -> { where(data_resource_type: "PointOfInterest") }, foreign_key: :data_resource_id
  has_many :categories, through: :data_resource_categories
  has_many :opening_hours, as: :openingable, dependent: :destroy
  has_many :price_informations, as: :priceable, class_name: "Price", dependent: :destroy
  has_one :location, as: :locateable, dependent: :destroy
  has_many :lunches, dependent: :destroy

  accepts_nested_attributes_for :price_informations, :opening_hours, :location, :lunches

  def unique_id
    fields = [name, type]

    first_address = addresses.first
    address_keys = %i[street zip city kind]
    address_fields = address_keys.map { |a| first_address.try(:send, a) }

    generate_checksum(fields + address_fields)
  end

  def settings
    data_provider.data_resource_settings.where(data_resource_type: "PointOfInterest").first.try(:settings)
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
