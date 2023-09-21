module Mutations
  class ImportGtfsFeeds < BaseMutation
    argument :dataprovider_id, ID, required: false
    argument :feed, String, required: false

    type Types::StatusType

    def resolve(dataprovider_id:, feed:)
      status, status_code = ["Import failed: No data provider found", 404] unless dataprovider_id.present?

      if dataprovider_id.present?
        # TODO: Implement feed parameter to start only given feed and not all feeds
        #   - check if data_provider exists
        #   - filter for feed parameter
        GtfsImporterJob.perform_later
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
