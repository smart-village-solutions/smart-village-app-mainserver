# frozen_string_literal: true

# This model organizes different categories as a category tree with the help of the ancestry
# gem.
class Category < ApplicationRecord
  has_ancestry orphan_strategy: :destroy
  validates_presence_of :name
  validates_uniqueness_of :name
  has_many :data_resource_categories
  has_many :event_records, source: :data_resource, source_type: "EventRecord", through: :data_resource_categories
  has_many :points_of_interest, source: :data_resource, source_type: "PointOfInterest", through: :data_resource_categories
  has_many :tours, source: :data_resource, source_type: "Tour", through: :data_resource_categories
  has_many :news_items, source: :data_resource, source_type: "NewsItem", through: :data_resource_categories

  def points_of_interest_count
    return 0 if points_of_interest.blank?

    points_of_interest.count
  end

  def tours_count
    return 0 if tours.blank?

    tours.count
  end

  def news_items_count
    return 0 if news_items.blank?

    news_items.count
  end

  def event_records_count
    return 0 if event_records.blank?

    event_records.count
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
