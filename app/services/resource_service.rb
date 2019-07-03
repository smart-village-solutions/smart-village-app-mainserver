# frozen_string_literal: true

class ResourceService
  attr_accessor :data_provider
  attr_accessor :resource
  attr_accessor :resource_class

  def initialize(data_provider:)
    @data_provider = data_provider
  end

  def create(resource_class, params)
    @params = params
    @resource_class = resource_class
    @resource = resource_class.new(params)
    @resource.data_provider = data_provider

    # skip create if already exists
    external_resource = find_external_resource
    return external_resource.external if external_resource.present?

    # create resource
    create_external_resource if resource.save
    resource
  end

  def find_external_resource
    return if @params.fetch(:force_create, false)

    ExternalReference.find_by(
      data_provider: data_provider,
      external_type: resource_class,
      unique_id: resource.unique_id
    )
  end

  def create_external_resource
    ExternalReference.create(
      data_provider: data_provider,
      external_id: resource.id,
      external_type: resource_class,
      unique_id: resource.unique_id
    )
  end
end
