class Location < ApplicationRecord
    has_one :geo_location, as: :geo_locateable
    belongs_to :locateable, polymorphic: true
end

# == Schema Information
#
# Table name: locations
#
#  id              :bigint(8)        not null, primary key
#  name            :string(255)
#  department      :string(255)
#  district        :string(255)
#  region          :string(255)
#  state           :string(255)
#  country         :string(255)
#  locateable_type :string(255)
#  locateable_id   :bigint(8)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
