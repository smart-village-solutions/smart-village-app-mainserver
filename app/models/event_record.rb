# frozen_string_literal: true

# this model describes the data for an event e.g. a concert or a reading.
class EventRecord < ApplicationRecord
  attr_accessor :category_name
  attr_accessor :region_name
  attr_accessor :force_create

  before_validation :find_or_create_category
  before_validation :find_or_create_region

  belongs_to :category, optional: true
  belongs_to :region, optional: true
  belongs_to :data_provider

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

  scope :filtered_for_current_user, lambda { |current_user|
    return all if current_user.admin_role?

    where(data_provider_id: current_user.data_provider_id)
  }

  accepts_nested_attributes_for :urls, reject_if: ->(attr) { attr[:url].blank? }
  accepts_nested_attributes_for :data_provider, :organizer,
                                :addresses, :location, :contacts,
                                :accessibility_information, :price_informations, :media_contents,
                                :repeat_duration, :dates
  acts_as_taggable

  validates_presence_of :title

  def find_or_create_category
    self.category_id = Category.where(name: category_name).first_or_create.id
  end

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

  def list_date
    event_dates = dates.order(date_start: :asc)
    future_date = event_dates.select { |date| date.date_start > Time.zone.now }.first.try(:date_start)

    return future_date if future_date.present?

    event_dates.last.try(:date_start)
  end

  def settings
    data_provider.data_resource_settings.where(data_resource_type: "EventRecord").first.try(:settings)
  end
end

# == Schema Information
#
# Table name: event_records
#
#  id               :bigint           not null, primary key
#  parent_id        :integer
#  region_id        :bigint
#  description      :text(65535)
#  repeat           :boolean
#  title            :string(255)
#  category_id      :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  data_provider_id :integer
#  external_id      :string(255)
#
