class GeoLocation < ApplicationRecord
    belongs_to :location, optional: true
    belongs_to :adress, optional: true
end
