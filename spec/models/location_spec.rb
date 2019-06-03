# frozen_string_literal: true

require "rails_helper"

RSpec.describe Location, type: :model do
  it { is_expected.to belong_to(:locateable) }
  it { is_expected.to have_one(:geo_location) }
end

# == Schema Information
#
# Table name: locations
#
#  id              :bigint           not null, primary key
#  name            :string(255)
#  department      :string(255)
#  district        :string(255)
#  state           :string(255)
#  country         :string(255)
#  locateable_type :string(255)
#  locateable_id   :bigint
#  region_id       :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
