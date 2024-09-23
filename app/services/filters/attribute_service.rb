# frozen_string_literal: true

class Filters::AttributeService
  class << self
    def data_resource_types
      [Tour, PointOfInterest, NewsItem, EventRecord] + GenericItem.descendants
    end

    def all
      filters = []
      current_municipality = Municipality.find_by(id: MunicipalityService.municipality_id)
      return filters unless current_municipality

      data_resource_types.each do |data_resource_type|
        next unless data_resource_type.respond_to?(:available_filters)

        filters << map_defaults_with_custom_definition(data_resource_type, current_municipality)
      end

      filters.map do |filter|
        filter.deep_transform_keys { |key| key.to_s.camelize(:lower) }
      end
    end

    def map_defaults_with_custom_definition(data_resource_type, current_municipality)
      data_resource_filter = current_municipality.data_resource_filters.find_or_initialize_by(data_resource_type: data_resource_type.to_s)
      if data_resource_filter.config.present?
        municipality_filter_config = determine_municipality_filter_config(data_resource_filter)
      end
      {
        data_resource_type: data_resource_type.to_s,
        config: municipality_filter_config.presence || fallback_config(data_resource_type)
      }
    end

    # Determines the municipality filter configuration with default values.
    #
    # This method processes a given data resource filter and constructs a configuration
    # hash for municipalities, incorporating default values where necessary.
    #
    # @param data_resource_filter [Object] The data resource filter containing configuration details.
    # @return [Hash] A hash representing the municipality filter configuration with defaults applied.
    #
    # The method iterates through each filter in the data resource filter's configuration,
    # retrieves the corresponding filter configuration from the Filters::AttributeService,
    # and merges the default attribute values with those provided in the data resource filter.
    def determine_municipality_filter_config(data_resource_filter)
      municipality_config_with_defaults = {}
      # Iterate through each filter in the data resource filter's configuration stored in the database
      data_resource_filter.config.each do |filter_name, filter_attributes|
        municipality_config_with_defaults[filter_name] = {}
        # Retrieve the filter configuration from the Filters::AttributeService
        filter_config = Filters::AttributeService.send(filter_name)
        filter_config.fetch(:allowed_attributes, {}).each do |attribute, attribute_config|
          municipality_config_with_defaults[filter_name][attribute] =
            filter_attributes.fetch(attribute, attribute_config.fetch(:default, nil))
        end
      end

      municipality_config_with_defaults
    end

    # creates a configuration hash for the given `data_resource_type`.
    #
    # @param data_resource_type [Object] An object that defines the `available_filters` method.
    # @return [Hash] A hash containing the default configurations for the available filters.
    #
    # The method iterates through all available filters of the `data_resource_type` and retrieves the
    # corresponding configuration for each filter. For each attribute in the configuration, the default
    # value (`:default`) is extracted and inserted into the result hash.
    def fallback_config(data_resource_type)
      result = {}
      data_resource_type.available_filters.each do |filter_name|
        result[filter_name] = {}
        filter_config = Filters::AttributeService.send(filter_name)
        filter_config.fetch(:allowed_attributes, {}).each do |attribute, attribute_config|
          result[filter_name][attribute] = attribute_config.fetch(:default, nil)
        end
      end

      result
    end

    # === Filter definitions ===

    # {
    #   allowed_attributes: {
    #     radius: { type: Numeric, allow_nil: true }
    #   }
    # }

    def data_provider
      {
        allowed_attributes: {
          is_multiselect: { type: :boolean, allow_nil: true, default: false },
          searchable: { type: :boolean, allow_nil: true, default: false },
          default: { type: :string, allow_nil: true, default: nil },
          type: { type: :string, allow_nil: true, default: "dropdown" }
        }
      }
    end

    def date_start
      {
        allowed_attributes: {
          has_past_dates: { type: :boolean, allow_nil: true, default: false },
          has_future_dates: { type: :boolean, allow_nil: true, default: true },
          default: { type: :date, allow_nil: true, default: nil },
          type: { type: :string, allow_nil: true, default: "date" }
        }
      }
    end

    def date_end
      {
        allowed_attributes: {
          has_past_dates: { type: :boolean, allow_nil: true, default: false },
          has_future_dates: { type: :boolean, allow_nil: true, default: true },
          default: { type: :date, allow_nil: true, default: nil },
          type: { type: :string, allow_nil: true, default: "date" }
        }
      }
    end

    def category
      {
        allowed_attributes: {
          is_multiselect: { type: :boolean, allow_nil: true, default: true },
          searchable: { type: :boolean, allow_nil: true, default: false },
          default: { type: :string, allow_nil: true, default: nil },
          type: { type: :string, allow_nil: true, default: "dropdown" }
        }
      }
    end

    def location
      {
        allowed_attributes: {
          is_multiselect: { type: :boolean, allow_nil: true, default: false },
          searchable: { type: :boolean, allow_nil: true, default: false },
          default: { type: :string, allow_nil: true, default: nil },
          type: { type: :string, allow_nil: true, default: "dropdown" }
        }
      }
    end

    def radius_search
      {
        allowed_attributes: {
          options: { type: :array, allow_nil: true, default: %w[1 2 5 10 50 100] },
          default: { type: :string, allow_nil: true, default: nil },
          type: { type: :string, allow_nil: true, default: "slider" }
        }
      }
    end

    def saveable
      {
        allowed_attributes: {
          default: { type: :boolean, allow_nil: true, default: true },
          type: { type: :string, allow_nil: true, default: "checkbox" }
        }
      }
    end

    def active
      {
        allowed_attributes: {
          default: { type: :boolean, allow_nil: false, default: true }
        }
      }
    end
  end
end
