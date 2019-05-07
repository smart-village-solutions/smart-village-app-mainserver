class Location < ApplicationRecord
    belongs_to :locateable, polymorphic: true
    belongs_to :region
    has_one :geo_location, as: :geo_locateable
end

# == Schema Information
#
# Table name: locations
#
#  id              :bigint           not null, primary key
#  name            :string(255)
#  department      :string(255)
#  district        :string(255)
#  region          :string(255)
#  state           :string(255)
#  country         :string(255)
#  locateable_type :string(255)
#  locateable_id   :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
