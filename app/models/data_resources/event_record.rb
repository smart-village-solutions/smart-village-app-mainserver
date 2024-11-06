# frozen_string_literal: true

# this model describes the data for an event e.g. a concert or a reading.
class EventRecord < ApplicationRecord
  include FilterByRole
  extend OrderAsSpecified

  attr_accessor :category_name
  attr_accessor :category_names
  attr_accessor :region_name
  attr_accessor :force_create
  attr_accessor :in_date_range_start_date
  attr_accessor :date

  before_save :remove_emojis
  before_update :handle_recurring_dates
  after_create :handle_recurring_dates
  after_save :find_or_create_category
  before_validation :find_or_create_region
  after_find :set_date_accessor

  belongs_to :region, optional: true
  belongs_to :data_provider

  has_many :data_resource_categories, -> { where(data_resource_type: "EventRecord") }, foreign_key: :data_resource_id
  has_many :categories, through: :data_resource_categories
  has_many :urls, as: :web_urlable, class_name: "WebUrl", dependent: :destroy
  has_one :organizer, as: :companyable, class_name: "OperatingCompany", dependent: :destroy
  has_many :addresses, as: :addressable, dependent: :destroy
  has_one :location, as: :locateable, dependent: :destroy
  has_many :contacts, as: :contactable, dependent: :destroy
  has_one :accessibility_information, as: :accessable, dependent: :destroy
  has_many :price_informations, as: :priceable, class_name: "Price", dependent: :destroy
  has_many :media_contents, as: :mediaable, dependent: :destroy
  has_one :repeat_duration, dependent: :destroy
  has_many :dates, as: :dateable, class_name: "FixedDate", dependent: :destroy
  has_one :external_reference, as: :external, dependent: :destroy

  serialize :recurring_weekdays, Array

  # defined by FilterByRole
  # scope :visible, -> { where(visible: true) }

  delegate :upcoming, to: :dates, prefix: true

  scope :in_date_range, lambda { |start_date, end_date, order, offset|
    # ignore the first date for recurring events, because it is the original date object with
    # a time span that should not be listed in the returning event records.
    fixed_date_ids = FixedDate.joins("INNER JOIN event_records ON event_records.id = fixed_dates.dateable_id")
                       .where(dateable_type: "EventRecord")
                       .where("event_records.recurring = false OR fixed_dates.id != (SELECT MIN(fd.id) FROM fixed_dates fd WHERE fd.dateable_id = event_records.id)")
                       .where.not(date_start: nil)
                       .where("(date_start <= :end_date) AND (COALESCE(date_end, date_start) >= :start_date)", start_date: start_date, end_date: end_date)
                       .pluck(:id)
    events_in_timespan = joins(:dates).where(fixed_dates: { id: fixed_date_ids })

    # reject recurring events with just one date object, because all dates are outside the timespan.
    # the one date object is the original date of the recurring event, that need to be ignored.
    # and ignore events with list date outside the timespan
    events_in_timespan = events_in_timespan.reject do |event_record|
      (event_record.recurring? && event_record.dates.size == 1) ||
      (event_record.list_date < start_date || event_record.list_date > end_date)
    end

    events_in_timespan.each do |event_record|
      # return the date_start of the event if the requested start_date is before event date_start
      current_events_date = event_record.date || event_record.dates.first

      if start_date < current_events_date.date_start
        event_record.in_date_range_start_date = current_events_date.date_start
      else
        event_record.in_date_range_start_date = start_date
      end
    end

    if order == "listDate_ASC"
      events_in_timespan = events_in_timespan.sort_by(&:list_date)
    elsif order == "listDate_DESC"
      events_in_timespan = events_in_timespan.sort_by(&:list_date).reverse
    end

    if offset.present? && offset.to_i > 0
      events_in_timespan = events_in_timespan.drop(offset.to_i)
    end

    events_in_timespan
  }

  scope :upcoming, lambda { |current_user = nil|
    event_records = if current_user.present?
                      filtered_for_current_user(current_user)
                    else
                      all
                    end

    event_records
      .joins(:dates)
      .where("fixed_dates.date_start >= ? OR fixed_dates.date_end >= ?", Date.today, Date.today)
      .distinct
  }

  scope :upcoming_with_date_select, lambda {
    select_clause = <<~SQL
      event_records.*,
      fixed_dates.id AS fixed_date_id,
      fixed_dates.date_start AS fixed_date_start,
      fixed_dates.date_end AS fixed_date_end,
      fixed_dates.time_start AS fixed_time_start,
      fixed_dates.time_end AS fixed_time_end,
      fixed_dates.weekday AS fixed_weekday,
      fixed_dates.time_description AS fixed_time_description,
      fixed_dates.use_only_time_description AS fixed_use_only_time_description
    SQL

    # ignore the first date for recurring events, because it is the original date object with
    # a time span that should not be listed in the returning event records.
    where("event_records.recurring = false OR fixed_dates.id != (SELECT MIN(fd.id) FROM fixed_dates fd WHERE fd.dateable_id = event_records.id)")
      .select(select_clause)
  }

  scope :by_category, lambda { |category_id|
    where(categories: { id: category_id }).joins(:categories)
  }

  scope :by_location, lambda { |location_name|
    where(locations: { name: location_name }).or(where(addresses: { city: location_name }))
      .left_joins(:location).left_joins(:addresses)
  }

  accepts_nested_attributes_for :urls, reject_if: ->(attr) { attr[:url].blank? }
  accepts_nested_attributes_for :data_provider, :organizer,
                                :addresses, :location, :contacts,
                                :accessibility_information, :price_informations, :media_contents,
                                :repeat_duration, :dates
  acts_as_taggable

  validates_presence_of :title

  def find_or_create_region
    self.region_id = Region.where(name: region_name).first_or_create.id
  end

  # Wenn es eine ExternalId gibt, dann wird dieses als unique_id verwendet
  def unique_id
    return generate_checksum([external_id]) if external_id.present?

    fields = [title]

    first_address = addresses.first
    address_keys = %i[street zip city kind]
    address_fields = address_keys.map { |a| first_address.try(:send, a) }

    date = dates.first
    date_keys = %i[date_start time_start]
    date_fields = date_keys.map { |d| date.try(:send, d) }

    generate_checksum(fields + address_fields + date_fields)
  end

  def compareable_attributes
    except_attributes = ["id", "created_at", "updated_at", "tag_list", "category_id", "region_id", "dateable_id", "addressable_id"]

    list_of_attributes = {}
    list_of_attributes.merge!(attributes.except(*except_attributes))
    list_of_attributes.merge!(dates: dates.map { |date| date.attributes.except(*except_attributes) })
    list_of_attributes.merge!(addresses: addresses.map { |address| address.attributes.except(*except_attributes) })

    list_of_attributes
  end

  # @return [Date]
  def list_date
    if date.present?
      return today_in_time_range(
        OpenStruct.new(
          date_start: date.date_start,
          date_end: date.date_end
        )
      )
    end

    return in_date_range_start_date if in_date_range_start_date.present?

    list_date_cached = RedisAdapter.get_event_list_date(id)
    if list_date_cached.present?
      return list_date_cached.to_i.zero? ? nil : Time.zone.at(list_date_cached.to_i).to_date
    end

    event_dates = dates.order(date_start: :asc)
    # ignore the first date if recurring, because it is the original date object with a time span
    event_dates = event_dates[1..-1] if recurring?
    dates_count = event_dates.size

    if dates_count.zero?
      RedisAdapter.set_event_list_date(id, 0)
      return nil
    end

    future_dates = event_dates.select do |date|
      date.date_start.try(:to_time).to_i > Time.zone.now.beginning_of_day.to_i
    end

    event_dates = event_dates - future_dates

    past_dates = event_dates.select do |date|
      date.date_start.try(:to_time).to_i < Time.zone.now.beginning_of_day.to_i &&
      date.date_end.present? &&
      date.date_end.try(:to_time).to_i < Time.zone.now.beginning_of_day.to_i
    end

    event_dates = event_dates - past_dates

    if event_dates.any?
      event_start_dates = event_dates.map do |event_date|
        today_in_time_range(event_date)
      end.compact.uniq.sort

      calculated_list_date = event_start_dates.first

      if calculated_list_date.blank?
        RedisAdapter.set_event_list_date(id, 0)
        return nil
      end

      RedisAdapter.set_event_list_date(id, calculated_list_date.try(:to_time).to_i)
      return calculated_list_date
    end

    if future_dates.present?
      calculated_list_date = future_dates.first.try(:date_start)
      RedisAdapter.set_event_list_date(id, calculated_list_date.try(:to_time).to_i)
      return calculated_list_date
    end

    calculated_list_date = event_dates.last.try(:date_start)
    RedisAdapter.set_event_list_date(id, calculated_list_date.try(:to_time).to_i)
    calculated_list_date
  end

  def settings
    data_provider.data_resource_settings.where(data_resource_type: "EventRecord").first.try(:settings)
  end

  # Sicherstellung der Abwärtskompatibilität seit 09/2020
  def category
    ActiveSupport::Deprecation.warn(":category is replaced by has_many :categories")
    categories.first
  end

  def content_for_facebook
    {
      message: [title, description].compact.join("\n\n"),
      link: ""
    }
  end

  private

    def set_date_accessor
      return if self[:fixed_date_id].blank?

      self.date = OpenStruct.new(
        id: self[:fixed_date_id],
        date_start: self[:fixed_date_start],
        date_end: self[:fixed_date_end],
        time_start: self[:fixed_time_start]&.in_time_zone,
        time_end: self[:fixed_time_end]&.in_time_zone,
        weekday: self[:fixed_weekday],
        time_description: self[:fixed_time_description],
        use_only_time_description: self[:fixed_use_only_time_description]
      )
    end

    def find_or_create_category
      # für Abwärtskompatibilität, wenn nur ein einiger Kategorienamen angegeben wird
      # ist der attr_accessor :category_name befüllt
      if category_name.present?
        category_to_add = Category.where(name: category_name).first_or_create
        categories << category_to_add unless categories.include?(category_to_add)
      end

      # Wenn mehrere Kategorien auf einmal gesetzt werden
      # ist der attr_accessor :category_names befüllt
      if category_names.present?
        category_names.each do |category|
          next unless category[:name].present?

          category_to_add = Category.where(name: category[:name]).first_or_create
          categories << category_to_add unless categories.include?(category_to_add)
        end
      end
    end

    # if a start and end date describes a larger time range, "today" needs to be returned until end
    # is reached.
    def today_in_time_range(date)
      start_date = date.date_start
      end_date = date.date_end
      today = Time.zone.now.beginning_of_day

      # return start date if start date is in the future
      return start_date if start_date >= today

      # return "today" if there is no end date
      return today.to_date if end_date.blank?

      # return nil if the end date is in the past
      return nil if end_date < today

      # return "today" if there is a future end date
      today.to_date
    end

    def remove_emojis
      self.title = RemoveEmoji::Sanitize.call(title) if title.present?
      self.description = RemoveEmoji::Sanitize.call(description) if description.present?
    end

    # Check if `recurring` is true and if so, handle recurring dates following the given pattern.
    # This method is called after the event is created or updated and recreates dates based on the
    # given recurring pattern. The creation takes place in a background job to avoid long running
    # requests. If `recurring` is false, recurring patterns gets reset.
    def handle_recurring_dates
      if recurring? && (new_record? || recurring_pattern_changed? || event_date_changed?)
        RecurringDatesForEventService.new(self).delay.create_with_pattern
      end

      reset_recurring_attributes if !recurring? && recurring_changed?
    end

    def reset_recurring_attributes
      self.recurring_weekdays = nil
      self.recurring_type = nil
      self.recurring_interval = nil
    end

    def recurring_pattern_changed?
      recurring_weekdays_changed? || recurring_type_changed? || recurring_interval_changed?
    end

    def event_date_changed?
      date = dates.first

      date.date_start_changed? || date.date_end_changed? || date.time_start_changed? ||
        date.time_end_changed?
    end
end

# == Schema Information
#
# Table name: event_records
#
#  id                 :bigint           not null, primary key
#  parent_id          :integer
#  region_id          :bigint
#  description        :text(65535)
#  repeat             :boolean
#  title              :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  data_provider_id   :integer
#  external_id        :string(255)
#  visible            :boolean          default(TRUE)
#  recurring          :boolean          default(FALSE)
#  recurring_weekdays :string(255)
#  recurring_type     :integer
#  recurring_interval :integer
#
