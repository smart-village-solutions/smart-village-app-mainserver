# frozen_string_literal: true

class Tour < Attraction
  has_many :geometry_tour_data, as: :geo_locateable, class_name: "GeoLocation"
  # eine Tour geht durch mehrere regionen. Eine RegionenTabelle haben wir aber nicht. Was machen.
  # Doch eine erstellen auf die sich dann auch location bezieht ? Ich würde sagen ja.
  enum means_of_transportation: %i[bike canoe foot]
end
