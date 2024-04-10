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
  let(:context) { { current_user: user } }
  let(:variables) {
    {
      excludeFilter: {
        "1": ["dp_1"],
        "2": ["poi_2"],
        "3": [],
        "4": ["dp_1", "poi_2"]
      }.to_json
    }
  }

  before do
    MunicipalityService.municipality_id = municipality.id

    data_provider1 = create(:data_provider, id: 1, municipality: municipality, name: 'Data Provider 1')
    data_provider2 = create(:data_provider, id: 2, municipality: municipality, name: 'Data Provider 2')

    poi = create(:point_of_interest, id: 2, data_provider_id: data_provider1.id, name: 'POI 1')

    category1 = create(:category, id: 1, name: 'Category 1')
    category2 = create(:category, id: 2, name: 'Category 2')
    category3 = create(:category, id: 3, name: 'Category 3')
    category4 = create(:category, id: 4, name: 'Category 4')

    event1 = create(:event_record, title: 'Event 1', data_provider_id: data_provider1.id, categories: [category1])
    event2 = create(:event_record, title: 'Event 2', data_provider_id: data_provider1.id , categories: [category2])
    event3 = create(:event_record, title: 'Event 3', data_provider_id: data_provider1.id , categories: [category3])
    event4 = create(:event_record, title: 'Event 4', data_provider_id: data_provider2.id , categories: [category1])
    event5 = create(:event_record, title: 'Event 5', data_provider_id: data_provider1.id , categories: [category2], point_of_interest_id: poi.id)
    event6 = create(:event_record, title: 'Event 6', data_provider_id: data_provider1.id , categories: [category4], point_of_interest_id: poi.id)

    [event1, event2, event3, event4, event5].each do |event|
      event.dates.create!(date_start: Time.current, date_end: Time.current + rand(1..5).days)
    end
  end

  context "with all variables sent" do
    it do
      is_expected.to eq([
        { "title"=>"Event 2" },
        { "title"=>"Event 4" },
      ])
    end
  end
end
