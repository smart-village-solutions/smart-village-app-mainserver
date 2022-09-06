# frozen_string_literal: true

class Waste::Tour < ApplicationRecord
  has_many :waste_location_types, class_name: "Waste::LocationType", foreign_key: "waste_tour_id", dependent: :destroy
  has_many :pick_up_times, class_name: "Waste::PickUpTime", foreign_key: "waste_tour_id", dependent: :destroy
  attr_accessor :force_create
  scope :filtered_for_current_user, ->(_current_user) { all }
end

# == Schema Information
#
# Table name: waste_tours
#
#  id         :bigint           not null, primary key
#  title      :string(255)
#  waste_type :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
