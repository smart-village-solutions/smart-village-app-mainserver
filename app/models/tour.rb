class Tour < Attraction
  has_many :geometry_tour_data, as: :geo_locateable, class_name: "GeoLocation"
  has_many :regions, as: :regionable
  enum means_of_transportation: [bike: 0, canoe: 1, foot: 2]
end