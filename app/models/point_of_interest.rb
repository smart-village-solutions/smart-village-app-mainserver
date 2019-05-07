# frozen_string_literal: true

#
# All locations which are interesting and attractive for the public in the
# smart village and the surrounding area
#
class PointOfInterest < Attraction
  has_many :opening_hours, as: :openingable
  has_many :prices, as: :priceable
  has_many :accessibilty_informations, as: :accessable
  has_many :certificates
  has_one :location, as: :locateable
end
