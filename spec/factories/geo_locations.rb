FactoryBot.define do
  factory :geo_location do
    latitude { 1.5 }
    longitude { 1.5 }
  end
end

# == Schema Information
#
# Table name: geo_locations
#
#  id                  :bigint           not null, primary key
#  latitude            :float(53)
#  longitude           :float(53)
#  geo_locateable_type :string(255)
#  geo_locateable_id   :bigint
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
