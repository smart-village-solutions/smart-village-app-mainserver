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
  has_many :generic_items, source: :data_resource, source_type: "GenericItem", through: :data_resource_categories

  after_destroy :cleanup_data_resource_settings

  def generic_items_count
    return 0 if generic_items.blank?

    generic_items.visible.count
  end

  def points_of_interest_count
    return 0 if points_of_interest.blank?

    points_of_interest.visible.count
  end

  def points_of_interest_tree_count
    points_of_interest.visible.count +
      descendants.map { |d| d.points_of_interest.visible.count }.compact.sum
  end

  def tours_count
    return 0 if tours.blank?

    tours.visible.count
  end

  def tours_tree_count
    tours.visible.count + descendants.map { |d| d.tours.visible.count }.compact.sum
  end

  def news_items_count
    return 0 if news_items.blank?

    news_items.visible.count
  end

  def event_records_count
    return 0 if event_records.blank?

    event_records.visible.count
  end

  def upcoming_event_records
    event_records.upcoming(nil)
  end

  def upcoming_event_records_count
    return 0 if event_records.blank?
    return 0 if upcoming_event_records.blank?

    upcoming_event_records.count
  end

  # Wenn eine Kategorie gelöscht wird kann es jedoch sein,
  # dass diese ID noch in den ResourceSettings eines DataProviders verwendet wird.
  # Nach dem Löschen der Kategorie müssen also auch die Verweise in DataResourceSetting
  # aufgeräumt werden
  def cleanup_data_resource_settings
    DataResourceSetting.where.not(settings: nil).each do |data_resource_setting|
      next if data_resource_setting.default_category_ids.blank?
      next unless data_resource_setting.default_category_ids.include?(id.to_s)

      data_resource_setting.default_category_ids.delete(id.to_s)
      data_resource_setting.save
    end
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
