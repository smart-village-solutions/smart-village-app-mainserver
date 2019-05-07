# frozen_string_literal: true

#
# Table for all regions which are relevant for the smart village app.
#
class Region < ApplicationRecord
  has_many :tours
  has_many :locations
end
