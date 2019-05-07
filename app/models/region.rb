# frozen_string_literal: true

#
# Table for all regions which are relevant for the smart village app.
#
class Region < ApplicationRecord
  belongs_to :regionable, polymorphic: true
  has_many :locations
end
