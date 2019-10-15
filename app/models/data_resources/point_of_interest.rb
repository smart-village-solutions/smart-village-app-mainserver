# frozen_string_literal: true

#
# All locations which are interesting and attractive for the public in the
# smart village and the surrounding area
#
class PointOfInterest < Attraction
  attr_accessor :force_create

  has_many :opening_hours, as: :openingable, dependent: :destroy
  has_many :price_informations, as: :priceable, class_name: "Price", dependent: :destroy
  has_one :location, as: :locateable, dependent: :destroy

  scope :filtered_for_current_user, ->(current_user) do
    return all if current_user.admin_role?

    where(data_provider_id: current_user.data_provider_id)
  end

  accepts_nested_attributes_for :price_informations, :opening_hours, :location

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
#  category_id             :bigint
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  type                    :string(255)      default("PointOfInterest"), not null
#  data_provider_id        :integer
#
