module Mutations
  class ImportGtfsFeeds < BaseMutation
    argument :dataprovider_id, ID, required: false
    argument :feed, String, required: false

    type Types::StatusType

    def resolve(dataprovider_id:, feed:)
      status, status_code = ["Import failed: No data provider given", 404] unless dataprovider_id.present?
      status, status_code = ["Import failed: No feed given", 404] unless feed.present?

      if dataprovider_id.present? && DataProvider.all.pluck(:id).include?(dataprovider_id.to_i)
        GtfsImporterJob.perform_later(feed_name: feed, data_provider_id: dataprovider_id)
        status, status_code = ["Import started", 200]
      end

      OpenStruct.new(
        id: dataprovider_id,
        status: status,
        status_code: status_code
      )
    end
  end
end
