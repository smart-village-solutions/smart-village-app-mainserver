# frozen_string_literal: true

require "rails_helper"

RSpec.describe PointOfInterest, type: :model do
  it { is_expected.to have_many(:addresses) }
  it { is_expected.to have_one(:contact) }
  it { is_expected.to have_one(:operating_company) }
  it { is_expected.to belong_to(:data_provider) }
  it { is_expected.to have_many(:media_contents) }
  it { is_expected.to have_many(:web_urls) }
  it { is_expected.to have_many(:opening_hours) }
  it { is_expected.to have_many(:price_informations) }
  it { is_expected.to have_one(:accessibility_information) }
  it { is_expected.to have_many(:lunches) }
  it { is_expected.to have_many(:travel_times) }
  it { is_expected.to validate_presence_of(:name) }

  describe "associations" do
    let(:point_of_interest) { create(:point_of_interest) }

    it "should only have travel_times with dateable_type 'PointOfInterest'" do
      travel_time_for_poi = point_of_interest.travel_times.create

      travel_time_loaded_from_db = PublicTransportation::TravelTime.find(travel_time_for_poi.id)
      expect(point_of_interest.travel_times).to include(travel_time_for_poi)
      expect(travel_time_loaded_from_db.dateable_type).to eq("PointOfInterest")
      expect(travel_time_loaded_from_db.type).to eq("PublicTransportation::TravelTime")
    end

    it "should behave as before on model EventRecord" do
      event_record = create(:event_record)
      event_record.dates.create

      event_record.reload

      expect(event_record.dates.count).to eq(1)
      expect(event_record.dates.first.dateable_type).to eq("EventRecord")
      expect(event_record.dates.first.type).to eq(nil)
    end
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
