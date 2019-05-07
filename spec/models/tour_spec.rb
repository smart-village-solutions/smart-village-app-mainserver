# frozen_string_literal: true

require "rails_helper"

RSpec.describe Tour, type: :model do
  it { is_expected.to have_many(:geometry_tour_data) }
  it { is_expected.to have_many(:regions) }
  it { is_expected.to define_enum_for(:means_of_transportation) }
end
