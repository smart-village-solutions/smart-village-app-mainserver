# frozen_string_literal: true

module MunicipalityScope
  extend ActiveSupport::Concern

  included do
    default_scope(all_queries: true) do
      accessible_municipality_ids = [MunicipalityService.municipality_id] + Municipality.global.pluck(:id)
      where(municipality_id: Array(accessible_municipality_ids.compact.uniq))
    end
  end
end
