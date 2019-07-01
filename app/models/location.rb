# frozen_string_literal: true

class Location < ApplicationRecord
  attr_accessor :region_name

  before_validation :find_or_create_region

  belongs_to :locateable, polymorphic: true
  belongs_to :region, optional: true
  has_one :geo_location, as: :geo_locateable, dependent: :destroy

  accepts_nested_attributes_for :geo_location,
                                reject_if: lambda { |attr|
                                             attr[:latitude].blank? || attr[:longitude].blank?
                                           }

  def find_or_create_region
    return if region_name.blank?

    self.region_id = Region.where(name: region_name).first_or_create.id
  end
end

# == Schema Information
#
# Table name: locations
#
#  id              :bigint           not null, primary key
#  name            :string(255)
#  department      :string(255)
#  district        :string(255)
#  state           :string(255)
#  country         :string(255)
#  locateable_type :string(255)
#  locateable_id   :bigint
#  region_id       :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
