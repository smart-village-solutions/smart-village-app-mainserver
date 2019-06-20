# frozen_string_literal: true

#
# Attraction is the superclass for all (touristic) attractions in the smart village.
#
class Attraction < ApplicationRecord
  attr_accessor :category_name

  before_validation :find_or_create_category

  belongs_to :category
  belongs_to :data_provider

  has_and_belongs_to_many :certificates, optional: true
  has_and_belongs_to_many :regions, optional: true
  has_many :addresses, as: :addressable
  has_one :contact, as: :contactable
  has_many :media_contents, as: :mediaable
  has_one :accessibility_information, as: :accessable
  has_one :operating_company, as: :companyable
  has_many :web_urls, as: :web_urlable

  validates_presence_of :name
  acts_as_taggable

  accepts_nested_attributes_for :web_urls, reject_if: ->(attr) { attr[:url].blank? }
  accepts_nested_attributes_for :addresses, :contact, :media_contents,
                                :accessibility_information, :operating_company,
                                :data_provider, :certificates,
                                :regions

  def find_or_create_category
    return if self.category.present?
    self.category_id = Category.where(name: category_name).first_or_create.id
  end
end

# == Schema Information
#
# Table name: attractions
#
#  id                      :bigint           not null, primary key
#  name                    :string(255)
#  description             :text(65535)
#  mobile_description      :string(255)
#  active                  :boolean          default(TRUE)
#  length_km               :integer
#  means_of_transportation :integer
#  category_id             :bigint
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  type                    :string(255)      default("PointOfInterest"), not null
#  data_provider_id        :integer
#
