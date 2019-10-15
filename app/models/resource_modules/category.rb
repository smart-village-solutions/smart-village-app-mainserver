# frozen_string_literal: true

# This model organizes different categories as a category tree with the help of the ancestry
# gem.
class Category < ApplicationRecord
  has_ancestry
  validates_presence_of :name
  has_one :event_record
  has_many :points_of_interest,
           -> { where(attractions: { type: "PointOfInterest" }) },
           class_name: "Attraction"
  has_many :tours,
           -> { where(attractions: { type: "Tour" }) },
           class_name: "Attraction"

  def points_of_interest_count
    return 0 if points_of_interest.blank?

    points_of_interest.count
  end

  def tours_count
    return 0 if tours.blank?

    tours.count
  end
end

# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  tmb_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ancestry   :string(255)
#
