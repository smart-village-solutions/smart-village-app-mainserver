# frozen_string_literal: true

#
# Attraction is the superclass for all (touristic) attractions in the smart village.
#
class Attraction < ApplicationRecord
  include FilterByRole
  include Categorizable

  attr_accessor :force_create,
                :category_name,
                :category_names

  after_save :find_or_create_category # This is defined in the Categorizable module

  store :payload, coder: JSON

  belongs_to :data_provider

  has_and_belongs_to_many :certificates, optional: true
  has_and_belongs_to_many :regions, optional: true
  has_many :addresses, as: :addressable, dependent: :destroy
  has_one :contact, as: :contactable, dependent: :destroy
  has_many :media_contents, as: :mediaable, dependent: :destroy
  has_one :accessibility_information, as: :accessable, dependent: :destroy
  has_one :operating_company, as: :companyable, dependent: :destroy
  has_many :web_urls, as: :web_urlable, dependent: :destroy
  has_one :external_reference, as: :external, dependent: :destroy
  has_one :location, as: :locateable, dependent: :destroy

  scope :visible, -> { where(visible: true) }

  scope :by_category, lambda { |category_id|
    where(categories: { id: category_id }).joins(:categories)
  }

  scope :by_location, lambda { |location_name|
    where(locations: { name: location_name }).or(where(addresses: { city: location_name }))
      .left_joins(:location).left_joins(:addresses)
  }

  validates_presence_of :name
  acts_as_taggable

  accepts_nested_attributes_for :web_urls, reject_if: ->(attr) { attr[:url].blank? }
  accepts_nested_attributes_for :addresses, :contact, :media_contents,
                                :accessibility_information, :operating_company,
                                :data_provider, :certificates,
                                :regions, :location

  def content_for_facebook
    {
      message: [name, description].compact.join("\n\n"),
      link: ""
    }
  end

  # Sicherstellung der Abwärtskompatibilität seit 09/2020
  def category
    ActiveSupport::Deprecation.warn(":category is replaced by has_many :categories")
    categories.first
  end
end

# == Schema Information
#
# Table name: attractions
#
#  id                         :bigint           not null, primary key
#  external_id                :string(255)
#  name                       :string(255)
#  description                :text(65535)
#  mobile_description         :text(65535)
#  active                     :boolean          default(TRUE)
#  length_km                  :integer
#  means_of_transportation    :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  type                       :string(255)      default("PointOfInterest"), not null
#  data_provider_id           :integer
#  visible                    :boolean          default(TRUE)
#  payload                    :text(65535)
#  push_notifications_sent_at :datetime
#
