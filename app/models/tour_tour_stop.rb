# frozen_string_literal: true

class TourTourStop < ApplicationRecord
  belongs_to :tour
  belongs_to :tour_stop
end

# == Schema Information
#
# Table name: tour_tour_stops
#
#  id           :bigint           not null, primary key
#  tour_id      :integer
#  tour_stop_id :integer
#
