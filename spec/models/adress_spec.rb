# frozen_string_literal: true

require "rails_helper"

RSpec.describe Adress, type: :model do
  it { is_expected.to belong_to(:adressable) }
  it { is_expected.to have_one(:geo_location) }
  it { is_expected.to allow_value("test").for(:addition) }
  it { is_expected.to allow_value("Berlin").for(:city) }
  it { is_expected.to allow_value("Musterstraße 123").for(:street) }
  it { is_expected.to allow_value("12051").for(:zip) }
  it { is_expected.to allow_value("PointOfInterest").for(:adressable_type) }
  it { is_expected.to allow_value(2).for(:adressable_id) }
end

# == Schema Information
#
# Table name: adresses
#
#  id              :bigint           not null, primary key
#  addition        :string(255)
#  city            :string(255)
#  street          :string(255)
#  zip             :string(255)
#  adressable_type :string(255)
#  adressable_id   :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
