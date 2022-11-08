# frozen_string_literal: true

class TourStopAssignment < ApplicationRecord
  belongs_to :tour
  belongs_to :tour_stop, dependent: :destroy
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
