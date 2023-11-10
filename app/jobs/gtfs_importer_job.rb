class GtfsImporterJob < ApplicationJob
  queue_as :default

  # gtfsConfig =
  # {
  #   "feeds": [
  #     {
  #       "name": "GTFS Name",
  #       "url": "https://GTFS-URL",
  #       "data_provider_id": "7",
  #       "whitelist_poi": [
  #         "9014301",
  #         "9092195"
  #       ]
  #     }
  #   ]
  # }
  def perform(feed_name: nil, data_provider_id: nil)
    gtfs_config = StaticContent.find_by(name: "gtfsConfig").try(:content)
    return unless gtfs_config.present?
    return if feed_name.blank?
    return if data_provider_id.blank?

    gtfs_config = JSON.parse(gtfs_config)
    gtfs_config["feeds"].each do |gtfs_feed|
      next if feed_name != gtfs_feed["name"]
      next if data_provider_id.to_i != gtfs_feed["data_provider_id"].to_i

      data_provider = DataProvider.find_by(id: gtfs_feed["data_provider_id"])
      next unless data_provider.present?

      gtfs_url = gtfs_feed["url"]
      next unless gtfs_url.present?

      whitelist_poi = gtfs_feed.fetch("whitelist_poi", [])

      PublicTransportation::ImportService.new(gtfs_url, data_provider.id, whitelist_poi).call

      p "GTFS Importer Job done"
    end
  end
end
