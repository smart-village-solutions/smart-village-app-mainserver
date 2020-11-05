# frozen_string_literal: true

namespace :batch_defaults do
  desc "Sets default categories to all elements of a given data_provider and data_resource_type"
  task create: :environment do
    data_resource_type = ENV["DATA_RESOURCE_TYPE"]
    raise "data_resource_type does not exist" unless DataResourceSetting::DATA_RESOURCES.map(&:to_s).include?(data_resource_type)

    data_provider_id = ENV["DATAPROVIDER_ID"]
    data_provider = DataProvider.find_by(id: data_provider_id)
    raise "data_provider does not exist" if data_provider.blank?

    puts "Running batch action with data_provider_id #{data_provider_id} and data_resource_type #{data_resource_type}"

    default_category_ids = data_provider.settings(data_resource_type).try(:default_category_ids)
    raise "No default categories defined" if default_category_ids.blank?

    data_elements = data_provider.send(data_resource_type.underscore.pluralize)
    data_elements.each do |data_element|
      data_element.categories << Category.where(id: default_category_ids)
    end

    puts "#{data_elements.count} elements updated"
  end
end
