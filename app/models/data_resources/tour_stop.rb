# frozen_string_literal: true

#
# All stops of a tour which are interesting and have more detailed data
#
class TourStop < Attraction
  has_one :tour_tour_stop, class_name: "TourTourStop", foreign_key: :tour_stop_id
  has_one :tour, through: :tour_tour_stop
  has_many :data_resource_categories, -> { where(data_resource_type: "TourStop") }, foreign_key: :data_resource_id
  has_many :categories, through: :data_resource_categories

  def settings
    data_provider.data_resource_settings.where(data_resource_type: "TourStop").first.try(:settings)
  end
end

# == Schema Information
#
# Table name: attractions
#
#  id                      :bigint           not null, primary key
#  external_id             :integer
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
