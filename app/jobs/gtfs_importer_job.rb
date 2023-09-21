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
  def perform
    gtfs_config = StaticContent.find_by(name: "gtfsConfig").try(:content)
    return unless gtfs_config.present?

    gtfs_config = JSON.parse(gtfs_config)
    gtfs_config["feeds"].each do |gtfs_feed|
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
