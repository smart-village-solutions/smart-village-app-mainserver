# frozen_string_literal: true

require "rails_helper"

RSpec.describe Address, type: :model do
  it { is_expected.to belong_to(:addressable) }
  it { is_expected.to have_one(:geo_location) }
  it { is_expected.to allow_value("test").for(:addition) }
  it { is_expected.to allow_value("Berlin").for(:city) }
  it { is_expected.to allow_value("Musterstraße 123").for(:street) }
  it { is_expected.to allow_value("12051").for(:zip) }
  it { is_expected.to allow_value("Attraction").for(:addressable_type) }
  it { is_expected.to allow_value(2).for(:addressable_id) }
end

# == Schema Information
#
# Table name: addresses
#
#  id               :bigint           not null, primary key
#  addition         :string(255)
#  city             :string(255)
#  street           :string(255)
#  zip              :string(255)
#  kind             :integer          default("default")
#  addressable_type :string(255)
#  addressable_id   :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
