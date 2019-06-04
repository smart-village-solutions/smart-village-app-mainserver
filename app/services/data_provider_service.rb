class DataProviderService
  attr_accessor :data_provider

  def initialize(data_provider:)
    @data_provider = data_provider
  end

  def create_resource(resource, params)
    item = resource.new(params)
    item.data_provider_id = data_provider.id
    item.save!

    item
  end
end
