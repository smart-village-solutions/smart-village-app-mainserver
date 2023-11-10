module Mutations
  class ImportGtfsFeeds < BaseMutation
    argument :data_provider_id, ID, required: false
    argument :feed, String, required: false

    type Types::StatusType

    def resolve(data_provider_id:, feed:)
      status, status_code = ["Import failed: No data provider given", 404] unless data_provider_id.present?
      status, status_code = ["Import failed: No feed given", 404] unless feed.present?

      if data_provider_id.present? && DataProvider.all.pluck(:id).include?(data_provider_id.to_i)
        GtfsImporterJob.perform_later(feed_name: feed, data_provider_id: data_provider_id)
        status, status_code = ["Import started", 200]
      end

      OpenStruct.new(
        id: nil,
        status: status,
        status_code: status_code
      )
    end
  end
end
