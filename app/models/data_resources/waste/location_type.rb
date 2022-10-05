# frozen_string_literal: true

class Waste::LocationType < ApplicationRecord
  belongs_to :address, optional: true
  belongs_to :waste_tour, class_name: "Waste::Tour", foreign_key: "waste_tour_id", optional: true
  has_many :pick_up_times, class_name: "Waste::PickUpTime", foreign_key: "waste_location_type_id", dependent: :destroy

  validates_presence_of :waste_type
  accepts_nested_attributes_for :address

  def list_pick_up_dates
    pick_up_times.pluck(:pickup_date)
  end

  def self.waste_types
    static_content = StaticContent.where(name: "wasteTypes", data_type: "json").first.try(:content)
    return nil if static_content.blank?

    begin
      JSON.parse(static_content)
    rescue
      nil
    end
  end
end

# == Schema Information
#
# Table name: waste_location_types
#
#  id            :bigint           not null, primary key
#  waste_type    :string(255)
#  address_id    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  waste_tour_id :integer
#
