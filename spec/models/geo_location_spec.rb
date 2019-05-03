# frozen_string_literal: true

require "rails_helper"

RSpec.describe GeoLocation, type: :model do
  it { is_expected.to belong_to(:geo_locateable) }
  it { is_expected.to validate_numericality_of(:latitude) }
  it { is_expected.to validate_numericality_of(:longitude) }
end

# == Schema Information
#
# Table name: geo_locations
#
#  id                  :bigint           not null, primary key
#  latitude            :float(24)
#  longitude           :float(24)
#  geo_locateable_type :string(255)
#  geo_locateable_id   :bigint
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
