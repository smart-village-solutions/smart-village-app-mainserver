# frozen_string_literal: true

namespace :batch_destroy do
  desc "Destroys all elements of a given data_provider and data_resource_type"
  task records: :environment do
    municipality_id = ENV["MUNICIPALITY_ID"]
    MunicipalityService.municipality_id = municipality_id

    data_resource_type = ENV["DATA_RESOURCE_TYPE"]
    unless DataResourceSetting::DATA_RESOURCES.map(&:to_s).include?(data_resource_type)
      raise "data_resource_type does not exist"
    end

    data_provider_id = ENV["DATAPROVIDER_ID"]
    raise "data_provider_id is required" if data_provider_id.blank?

    data_resource_model = data_resource_type.constantize

    puts "Running batch action with data_provider_id #{data_provider_id} and data_resource_type #{data_resource_type}"
    data_elements = data_resource_model.where(data_provider_id: data_provider_id)
    puts "Will destroy #{data_elements.count} #{data_resource_type}"

    result = data_elements.destroy_all
    puts "Destroyed #{result.count} #{data_resource_type}"
  end
end
