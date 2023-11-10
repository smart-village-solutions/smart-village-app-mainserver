# frozen_string_literal: true

require "rails_helper"

RSpec.describe PublicTransportation::ImportService, type: :service do
  before do
    static_content = {
      "feeds": [
        {
          "name": "GTFS MQ",
          "url": "https://www.connect-info.net/opendata/gtfs/connect-nds-toplevel/xzmxkgmqyy",
          "data_provider_id": "7",
          "whitelist_poi": [
            "9099754",
            "000009099839",
            "000009099829",
            "000009099782"
          ]
        }
      ]
    }.to_json
    @gtfs_feeds = create(:static_content, name: "gtfsConfig", data_type: "json", content: static_content)
    @gtfs_config = JSON.parse(@gtfs_feeds.content)
    gtfs_feed = @gtfs_config["feeds"].first

    @data_provider_id = gtfs_feed["data_provider_id"]
    @gtfs_url = gtfs_feed["url"]
    @whitelist_poi = gtfs_feed.fetch("whitelist_poi", [])
  end

  let(:data_provider) { create(:data_provider) }

  describe "#initialize" do
    it "should initialize" do
      expect(described_class.new(@gtfs_url, @data_provider_id, @whitelist_poi)).to be_a(described_class)
    end
  end

  describe "#call" do
    it "should call" do
      expect(described_class.new(@gtfs_url, @data_provider_id, @whitelist_poi).call).to be_a(described_class)
    end

    it "should call parse stops" do
      expect_any_instance_of(described_class).to receive(:parse_stops)
      expect_any_instance_of(described_class).to receive(:parse_stop_times)
      described_class.new(@gtfs_url, @data_provider_id, @whitelist_poi).call
    end
  end
end
