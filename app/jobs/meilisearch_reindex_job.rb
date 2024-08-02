# frozen_string_literal: true

class MeilisearchReindexJob < ApplicationJob
  queue_as :default

  def perform
    Municipality.all.each do |municipality|
      MunicipalityService.municipality_id = municipality.id
      MeiliSearch::Rails.configuration[:timeout] = 3000
      EventRecord.in_batches(of: 10).each_record(&:index!)
      EventRecord.in_batches(of: 10).each_record(&:index!)
      NewsItem.in_batches(of: 10).each_record(&:index!)
      GenericItem.in_batches(of: 10).each_record(&:index!)
      PointOfInterest.in_batches(of: 10).each_record(&:index!)
    end
  end
end
