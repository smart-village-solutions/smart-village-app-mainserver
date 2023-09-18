# frozen_string_literal: true

#
# Attraction is the superclass for all (touristic) attractions in the smart village.
#
class Attraction < ApplicationRecord
  include FilterByRole

  attr_accessor :force_create
  attr_accessor :category_name
  attr_accessor :category_names

  before_save :remove_emojis
  after_save :find_or_create_category

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

  private

    # callback function which enables setting of category by
    # virtual attribute category name.
    # ATTENTION: With this callback the setting of category is only possible with category_name.
    #            PointOfInterest.create(category: Category.first) doesn't work anymore.
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

    def remove_emojis
      self.name = RemoveEmoji::Sanitize.call(name) if name.present?
      self.description = RemoveEmoji::Sanitize.call(description) if description.present?
      self.mobile_description = RemoveEmoji::Sanitize.call(mobile_description) if mobile_description.present?
    end
end

# == Schema Information
#
# Table name: attractions
#
#  id                      :bigint           not null, primary key
#  external_id             :string(255)
#  name                    :string(255)
#  description             :text(65535)
#  mobile_description      :text(65535)
#  active                  :boolean          default(TRUE)
#  length_km               :integer
#  means_of_transportation :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  type                    :string(255)      default("PointOfInterest"), not null
#  data_provider_id        :integer
#  visible                 :boolean          default(TRUE)
#  payload                 :text(65535)
#
