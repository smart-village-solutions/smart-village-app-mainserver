# == Schema Information
#
# Table name: geo_locations
#
#  id                  :bigint(8)        not null, primary key
#  latitude            :float(24)
#  longitude           :float(24)
#  geo_locateable_type :string(255)
#  geo_locateable_id   :bigint(8)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class GeoLocation < ApplicationRecord
    belongs_to :geo_locateable, polymorphic: true
end
