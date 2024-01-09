# frozen_string_literal: true

class EventRecordService
  # Update all EventRecord to set sort_dates depending on date today
  # without running any callbacks
  def self.update_sort_dates
    Municipality.all.each do |municipality|
      MunicipalityService.municipality_id = municipality.id
      data_provider_ids = municipality.users.map(&:data_provider_id).uniq.compact.flatten
      EventRecord.where(data_provider_id: data_provider_ids).each do |event_record|
        event_record.update_column(:sort_date, event_record.list_date)
      end
    end
  end
end
