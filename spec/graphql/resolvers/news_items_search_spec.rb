# frozen_string_literal: true
require "rails_helper"

# rubocop:disable all
describe Resolvers::NewsItemsSearch do
  include_context "with graphql"

  subject { data['newsItems'] }
  let(:query_string) do
    <<~GQL
      query NewsItems($excludeFilter: JSON) {
        newsItems(excludeFilter: $excludeFilter) {
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
        category3.id.to_s => [],
        category4.id.to_s => ["dp_#{data_provider1.id}", "poi_#{poi2.id}"]
      }.to_json
    }
  }

  before do
    MunicipalityService.municipality_id = municipality.id

    news_item1 = create(:news_item, title: 'news_item 1', data_provider_id: data_provider1.id, categories: [category1])
    news_item2 = create(:news_item, title: 'news_item 2', data_provider_id: data_provider1.id , categories: [category2])
    news_item3 = create(:news_item, title: 'news_item 3', data_provider_id: data_provider1.id , categories: [category3])
    news_item4 = create(:news_item, title: 'news_item 4', data_provider_id: data_provider2.id , categories: [category1])
    news_item5 = create(:news_item, title: 'news_item 5', data_provider_id: data_provider1.id , categories: [category2], point_of_interest_id: poi.id)
    news_item6 = create(:news_item, title: 'news_item 6', data_provider_id: data_provider1.id , categories: [category4], point_of_interest_id: poi.id)
  end

  context "with all variables sent" do
    it do
      is_expected.to match_array([
        { "title"=>"news_item 2" },
        { "title"=>"news_item 4" },
      ])
    end
  end
end
