# frozen_string_literal: true

class MeilisearchReindexJob < ApplicationJob
  queue_as :default

  def perform
    Municipality.all.each do |municipality|
      MunicipalityService.municipality_id = municipality.id
      MeiliSearch::Rails.configuration[:timeout] = 3000
      NewsItem.meilisearch_import.map(&:index!)
      EventRecord.meilisearch_import.map(&:index!)
      GenericItem.meilisearch_import.map(&:index!)
      PointOfInterest.meilisearch_import.map(&:index!)
    end
  end
end
