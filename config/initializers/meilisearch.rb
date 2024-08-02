# frozen_string_literal: true

MEILISEARCH_MAX_TOTAL_HITS = 100_000
MeiliSearch::Rails.configuration = {
  per_environment: true,
  active: true
}
