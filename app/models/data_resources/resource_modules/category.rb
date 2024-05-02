# frozen_string_literal: true

# This model organizes different categories as a category tree with the help of the ancestry
# gem.
class Category < ApplicationRecord
  has_ancestry orphan_strategy: :destroy
  acts_as_taggable
  validates_presence_of :name
  validates_uniqueness_of :name
  has_many :data_resource_categories
  has_many :event_records, source: :data_resource, source_type: "EventRecord", through: :data_resource_categories
  has_many :points_of_interest, source: :data_resource, source_type: "PointOfInterest", through: :data_resource_categories
  has_many :tours, source: :data_resource, source_type: "Tour", through: :data_resource_categories
  has_many :news_items, source: :data_resource, source_type: "NewsItem", through: :data_resource_categories
  has_many :generic_items, source: :data_resource, source_type: "GenericItem", through: :data_resource_categories
  has_one :contact, as: :contactable, dependent: :destroy

  TAG_OPTIONS = ["event_record", "news_item", "point_of_interest", "tour"] + GenericItem::GENERIC_TYPES.keys.map { |gt| "generic_item_#{gt}" }

  after_destroy :cleanup_data_resource_settings

  accepts_nested_attributes_for :contact

  def points_of_interest_tree_count(args = nil)
    if args.present? && args[:location].present?
      return points_of_interest.visible.by_location(args[:location]).count +
             descendants.map { |d| d.points_of_interest.visible.by_location(args[:location]).count }
               .compact.sum
    end

    points_of_interest.visible.count +
      descendants.map { |d| d.points_of_interest.visible.count }.compact.sum
  end

  def tours_tree_count(args = nil)
    if args.present? && args[:location].present?
      return tours.visible.by_location(args[:location]).count +
             descendants.map { |d| d.tours.visible.by_location(args[:location]).count }
               .compact.sum
    end

    tours.visible.count + descendants.map { |d| d.tours.visible.count }.compact.sum
  end

  def news_items_count
    return 0 if news_items.blank?

    news_items.visible.count
  end

  def upcoming_event_records
    event_records.upcoming
  end

  # Defines 2 methods for a list of record type:
  # - Returns the number of items the given location and record type
  # - Returns the items of the given location and record type
  [:event_records, :upcoming_event_records, :generic_items, :points_of_interest, :tours].each do |item_source|
    define_method "#{item_source}_by_location" do |args = nil|
      return [] if send(item_source).blank?
      return send(item_source).visible.by_location(args[:location]) if args.present? && args[:location].present?

      send(item_source).visible
    end

    define_method "#{item_source}_count_by_location" do |args = nil|
      items = send("#{item_source}_by_location", args)
      return 0 if items.blank?

      items.count
    end
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
#  id              :bigint           not null, primary key
#  name            :string(255)
#  tmb_id          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  ancestry        :string(255)
#  icon_name       :string(255)
#
