# frozen_string_literal: true

module GlobalMeilisearchHelper
  class << self
    def municipality_ids(municipality_id)
      ids = []
      ids << Array(Municipality.find(municipality_id).settings.dig(:activated_globals, :municipality_ids))
      ids << municipality_id

      ids.flatten.uniq.compact.delete_if(&:blank?)
    end

    def municipality_id_filters
      meili_filters = []
      meili_filters << GlobalMeilisearchHelper.municipality_ids(MunicipalityService.municipality_id).map { |f| "municipality_id = '#{f}'" }

      meili_filters
    end
  end
end
