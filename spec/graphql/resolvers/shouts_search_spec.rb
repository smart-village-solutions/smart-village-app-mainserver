# frozen_string_literal: true
require "rails_helper"

# rubocop:disable all
describe Resolvers::ShoutsSearch do
  include_context "with graphql"

  subject { data['shouts'] }
  let(:query_string) do
    <<~GQL
      query {
        shouts {
          title
          description
          dateStart
          dateEnd
          genericType
          timeStart
          timeEnd
          announcementTypes
          mediaContent {
            captionText
            sourceUrl {
              url
            }
          }
          
          location {
            geoLocation {
              latitude
              longitude
            }
          }
          
          maxNumberOfQuota
          quotaFrequency
          quotaVisibility
          
          organizer {
            organizerId
            organizerType
          }
          
          announcementableId
          announcementableType
          redemptionsList {
            id
            publicName
          }
          
          redemptionsCount
        }
      }
    GQL
  end

  let(:municipality) { create(:municipality, slug: 'test', title: 'test') }

  let(:category1) { create(:category, name: 'Category 1') }
  let(:category2) { create(:category, name: 'Category 2') }
  let(:dp) { create(:data_provider, municipality: municipality, name: 'Data Provider 1') }
  let(:event) { create(:event_record, title: 'Event 1', data_provider_id: dp.id, categories: [category1]) }
  let(:shout) { create(:generic_item, generic_type: GenericItem::GENERIC_TYPES[:announcement], data_provider_id: dp.id) }
  let(:user) { create(:user, role: :admin, municipality: municipality, data_provider_id: dp.id) }

  let(:context) { { current_user: user } }

  before do
    MunicipalityService.municipality_id = municipality.id
    opening_params = { date_from: Date.today, date_to: Date.today + 1.day, time_from: '10:00', time_to: '12:00' }
    location_params = { city: 'City', street: 'Street', geo_location_attributes: { latitude: 1.0, longitude: 1.0 } }
    quota_params = { max_quantity: 10, frequency: 0 }

    shout.categories << [category1, category2]
    shout.generic_itemable_type = 'EventRecord'
    shout.generic_itemable_id = event.id
    shout.opening_hours.create(opening_params)
    shout.addresses.create(location_params)
    shout.create_quota(quota_params)

    shout.save
  end

  context "with all variables sent" do
    it do
      is_expected.to match_array([
        {
          "title"=>"MyString",
          "description"=>"MyText",
          "dateStart"=>"2024-05-16",
          "dateEnd"=>"2024-05-17",
          "genericType"=>"Announcement",
          "timeStart"=>"10:00",
          "timeEnd"=>"12:00",
          "announcementTypes"=>["Category 1", "Category 2"],
          "mediaContent"=>nil,
          "location"=>{"geoLocation"=>{"latitude"=>1.0, "longitude"=>1.0}},
          "maxNumberOfQuota"=>10,
          "quotaFrequency"=>"once",
          "quotaVisibility"=>"private_visibility",
          "organizer"=>{"organizerId"=>user.data_provider_id.to_s, "organizerType"=>"data_provider"},
          "announcementableId"=>event.id.to_s,
          "announcementableType"=>"EventRecord",
          "redemptionsList"=>[],
          "redemptionsCount"=>0
        }
      ])
    end
  end
end
