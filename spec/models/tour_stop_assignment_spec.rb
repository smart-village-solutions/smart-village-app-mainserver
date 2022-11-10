# frozen_string_literal: true

require "rails_helper"

RSpec.describe TourStopAssignment, type: :model do
  it { is_expected.to belong_to(:tour) }
  it { is_expected.to belong_to(:tour_stop) }
end

# == Schema Information
#
# Table name: tour_stop_assignments
#
#  id           :bigint           not null, primary key
#  tour_id      :integer
#  tour_stop_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#
