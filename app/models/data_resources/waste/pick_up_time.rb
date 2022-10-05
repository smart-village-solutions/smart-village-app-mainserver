# frozen_string_literal: true

class Waste::PickUpTime < ApplicationRecord
  belongs_to :waste_location_type, class_name: "Waste::LocationType", foreign_key: "waste_location_type_id", optional: true
  belongs_to :waste_tour, class_name: "Waste::Tour", foreign_key: "waste_tour_id", optional: true

  validates_presence_of :pickup_date
  accepts_nested_attributes_for :waste_location_type
end

# == Schema Information
#
# Table name: waste_pick_up_times
#
#  id                     :bigint           not null, primary key
#  waste_location_type_id :integer
#  pickup_date            :date
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  waste_tour_id          :integer
#
