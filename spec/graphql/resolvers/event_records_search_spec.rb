# frozen_string_literal: true
require "rails_helper"

# rubocop:disable all
describe Resolvers::EventRecordsSearch do
  include_context "with graphql"

  subject { data['eventRecords'] }
  let(:query_string) do
    <<~GQL
      query EventRecords($excludeFilter: JSON) {
        eventRecords(excludeFilter: $excludeFilter) {
          title
        }
      }
    GQL
  end

  let(:municipality) { create(:municipality, slug: 'test', title: 'test') }
  let(:user) { create(:user, role: :admin, municipality: municipality) }

  let(:category1) { create(:category, name: 'Category 1') }
  let(:category2) { create(:category, name: 'Category 2') }
  let(:category3) { create(:category, name: 'Category 3') }
  let(:category4) { create(:category, name: 'Category 4') }
  let(:category5) { create(:category, name: 'Category 5') }
  let(:category6) { create(:category, name: 'Category 6') }
  let(:category7) { create(:category, name: 'Category 7') }

  let(:data_provider1) { create(:data_provider, municipality: municipality, name: 'Data Provider 1') }
  let(:data_provider2) { create(:data_provider, municipality: municipality, name: 'Data Provider 2') }

  let(:poi) { create(:point_of_interest, data_provider_id: data_provider1.id, name: 'POI 1') }
  let(:poi2) { create(:point_of_interest, data_provider_id: data_provider1.id, name: 'POI 2') }


  let(:context) { { current_user: user } }
  let(:variables) {
    {
      excludeFilter: {
        category1.id.to_s => ["dp_#{data_provider1.id}"],
        category2.id.to_s => ["poi_#{poi.id}"],
        "#{category3.id}_#{category5.id}" => [],
        category4.id.to_s => ["dp_#{data_provider1.id}", "poi_#{poi2.id}"],
        "#{category6.id}_#{category7.id}" => ["dp_#{data_provider1.id}", "poi_#{poi2.id}"],
      }.to_json
    }
  }

  before do
    MunicipalityService.municipality_id = municipality.id

    event1 = create(:event_record, title: 'Event 1', data_provider_id: data_provider1.id, categories: [category1])
    event2 = create(:event_record, title: 'Event 2', data_provider_id: data_provider1.id , categories: [category2])
    event3 = create(:event_record, title: 'Event 3', data_provider_id: data_provider1.id , categories: [category3])
    event4 = create(:event_record, title: 'Event 4', data_provider_id: data_provider2.id , categories: [category1])
    event5 = create(:event_record, title: 'Event 5', data_provider_id: data_provider1.id , categories: [category2], point_of_interest_id: poi.id)
    event6 = create(:event_record, title: 'Event 6', data_provider_id: data_provider1.id , categories: [category4], point_of_interest_id: poi.id)
    event7 = create(:event_record, title: 'Event 7', data_provider_id: data_provider1.id , categories: [category5])
    event8 = create(:event_record, title: 'Event 8', data_provider_id: data_provider1.id , categories: [category6])
    event9 = create(:event_record, title: 'Event 9', data_provider_id: data_provider2.id , categories: [category7], point_of_interest_id: poi.id)

    [event1, event2, event3, event4, event5, event6, event7, event8, event9].each do |event|
      event.dates.create!(date_start: Time.current, date_end: Time.current + rand(1..5).days)
    end
  end

  context "with all variables sent" do
    it do
      is_expected.to match_array([
        { "title"=>"Event 2" },
        { "title"=>"Event 4" },
        { "title"=>"Event 9" },
      ])
    end
  end
end
