# frozen_string_literal: true

module MunicipalityScope
  extend ActiveSupport::Concern

  included do
    default_scope(all_queries: true) { where(municipality_id: MunicipalityService.municipality_id) }
  end

end
