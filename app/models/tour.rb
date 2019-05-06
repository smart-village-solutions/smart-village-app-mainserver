class Tour < Attraction
  has_many :geometry_tour_data, as: :geo_locateable, class_name: "GeoLocation"
  # eine Tour geht durch mehrere regionen. Eine RegionenTabelle haben wir aber nicht. Was machen.
  # Doch eine erstellen auf die sich dann auch location bezieht? Ich würde sagen ja.
  enum means_of_transportation: [bike: 0, canoe: 1, foot: 2]
end