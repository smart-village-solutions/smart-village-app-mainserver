# frozen_string_literal: true

class MeilisearchReindexJob < ApplicationJob
  queue_as :default

  def perform
    Municipality.all.each do |municipality|
      MunicipalityService.municipality_id = municipality.id
      MeiliSearch::Rails.configuration[:timeout] = 3000
      EventRecord.all.map(&:index!)
      NewsItem.all.map(&:index!)
      GenericItem.all.map(&:index!)
      PointOfInterest.all.map(&:index!)
    end
  end
end
