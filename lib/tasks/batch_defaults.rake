# frozen_string_literal: true

namespace :batch_defaults do
  desc "Sets default categories to all elements of a given data_provider and data_resource_type"
  task create: :environment do
    data_resource_type = ENV["DATA_RESOURCE_TYPE"]
    raise "data_resource_type does not exist" unless DataResourceSetting::DATA_RESOURCES.map(&:to_s).include?(data_resource_type)

    data_provider_id = ENV["DATAPROVIDER_ID"]

    puts "Running batch action with data_provider_id #{data_provider_id} and data_resource_type #{data_resource_type}"
    CategoryService.new.set_defaults(data_resource_type: data_resource_type, data_provider_id: data_provider_id)

    puts "#{data_elements.count} elements updated"
  end
end
