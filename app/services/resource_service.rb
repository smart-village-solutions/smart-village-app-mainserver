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
    # skip create if record already exists and new record has the same attribute values as the new
    # record and the record was not provided by maz
    external_resource = find_external_resource
    old_record = external_resource.try(:external)
    return old_record if external_resource.present? &&
                         unchanged_attributes?(old_record) &&
                         not_always_recreate?(data_provider, resource_class)

    create_or_recreate(old_record, external_resource)
    resource_or_error_message(resource)
  end

  def create_or_recreate(old_record, external_resource)
    ActiveRecord::Base.transaction do
      old_record.destroy if old_record.present?
      # necessary because dependant: :destroy sometimes works for external resource
      # and sometimes doesn't
      # TODO: Remove line and make dependant: :destroy work
      external_resource.destroy if external_resource.present?
      create_external_resource if @resource.save
    end
  end

  def unchanged_attributes?(record)
    return false if record.blank?

    except_attributes = ["id", "created_at", "updated_at", "tag_list", "category_id", "region_id"]
    @resource.attributes.except(*except_attributes) == record.attributes.except(*except_attributes)
  end

  def not_always_recreate?(data_provider, resource_class)
    return false if data_provider.blank?

    class_name = resource_class.name.underscore
    data_provider.always_recreate[class_name] != true
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

  def resource_or_error_message(record)
    if record.valid?
      record
    else
      GraphQL::ExecutionError.new("Invalid input: #{record.errors.full_messages.join(", ")}")
    end
  end
end
