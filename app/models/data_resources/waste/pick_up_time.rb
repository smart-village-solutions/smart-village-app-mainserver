# frozen_string_literal: true

class Waste::PickUpTime < ApplicationRecord
  belongs_to :waste_location_type, class_name: "Waste::LocationType", foreign_key: "waste_location_type_id"

  validates_presence_of :pickup_date
  validates_presence_of :waste_location_type
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
#
