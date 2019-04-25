class Location < ApplicationRecord
    has_one :geo_location
    belongs_to :point_of_interest
end
