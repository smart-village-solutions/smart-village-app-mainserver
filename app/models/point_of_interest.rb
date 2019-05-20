# frozen_string_literal: true

#
# All locations which are interesting and attractive for the public in the
# smart village and the surrounding area
#
class PointOfInterest < Attraction
  has_many :opening_hours, as: :openingable
  has_many :prices, as: :priceable

  has_one :location, as: :locateable

  accepts_nested_attributes_for :prices, :opening_hours, :location
end

# == Schema Information
#
# Table name: attractions
#
#  id                      :bigint           not null, primary key
#  external_id             :integer
#  name                    :string(255)
#  description             :string(255)
#  mobile_description      :string(255)
#  active                  :boolean          default(TRUE)
#  means_of_transportation :integer
#  category_id             :bigint
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  type                    :string(255)      default("PointOfInterest"), not null
#
