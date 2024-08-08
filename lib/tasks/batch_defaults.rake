# frozen_string_literal: true

namespace :batch_defaults do
  desc "Sets default categories to all elements of a given data_provider and data_resource_type"
  task create: :environment do
    municipality_id = ENV["MUNICIPALITY_ID"]
    MunicipalityService.municipality_id = municipality_id

    data_resource_type = ENV["DATA_RESOURCE_TYPE"]
    unless DataResourceSetting::DATA_RESOURCES.map(&:to_s).include?(data_resource_type)
      raise "data_resource_type does not exist"
    end

    data_provider_id = ENV["DATAPROVIDER_ID"]

    puts "Running batch action with data_provider_id #{data_provider_id} and data_resource_type #{data_resource_type}"
    CategoryService.new.set_defaults(data_resource_type: data_resource_type, data_provider_id: data_provider_id)

    puts "#{data_elements.count} elements updated"
  end
end
