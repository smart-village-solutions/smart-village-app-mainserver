# frozen_string_literal: true

class Waste::Tour < ApplicationRecord
  has_many :waste_location_types, class_name: "Waste::LocationType"
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
