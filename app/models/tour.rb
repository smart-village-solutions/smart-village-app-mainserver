# frozen_string_literal: true

#
# A Tour is a planned route to walk ride or canoe and which passes through
# the surrounding areas of the Smart Village
#
class Tour < Attraction
  has_many :geometry_tour_data, as: :geo_locateable, class_name: "GeoLocation"
  has_and_belongs_to_many :regions
  enum means_of_transportation: { bike: 0, canoe: 1, foot: 2 }
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
#  length_km               :integer
#  means_of_transportation :integer
#  category_id             :bigint
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  type                    :string(255)      default("PointOfInterest"), not null
#
