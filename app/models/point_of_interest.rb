class PointOfInterest < Attraction
  has_many :opening_hours, as: :openingable
  has_many :prices, as: :priceable
  has_many :accessibilty_informations, as: :accessable
  has_many :certificates
end