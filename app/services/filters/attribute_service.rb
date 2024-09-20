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

      filters
    end

    def map_defaults_with_custom_definition(data_resource_type, current_municipality)
      data_resource_filter = current_municipality.data_resource_filters.find_or_initialize_by(data_resource_type: data_resource_type.to_s)

      {
        data_resource_type: data_resource_type.to_s,
        config: data_resource_filter.config.presence || fallback_config(data_resource_type)
      }
    end

    def fallback_config(data_resource_type)
      result = {}
      data_resource_type.available_filters.each do |filter_name|
        result[filter_name] = {}
        filter_config = Filters::AttributeService.send(filter_name)
        filter_config.fetch(:allowed_attributes, []).each do |attribute|
          result[filter_name][attribute] = filter_config.dig(:attribute_validations, attribute, :default)
        end
      end

      result
    end

    # === Filter definitions ===

    # {
    #   allowed_attributes: [:radius],
    #   attribute_validations: {
    #     radius: { type: Numeric, allow_nil: true }
    #   }
    # }
    def date_start
      {
        allowed_attributes: %i[default past_dates future_dates],
        attribute_validations: {
          past_dates: { type: :boolean, allow_nil: true, default: false },
          future_dates: { type: :boolean, allow_nil: true, default: true },
          default: { type: :date, allow_nil: true, default: nil }
        }
      }
    end

    def date_end
      {
        allowed_attributes: %i[default past_dates future_dates],
        attribute_validations: {
          past_dates: { type: :boolean, allow_nil: true, default: false },
          future_dates: { type: :boolean, allow_nil: true, default: true },
          default: { type: :date, allow_nil: true, default: nil }
        }
      }
    end

    def category
      {
        allowed_attributes: %i[default multiselect],
        attribute_validations: {
          multiselect: { type: :boolean, allow_nil: true, default: true },
          default: { type: :string, allow_nil: true, default: nil }
        }
      }
    end

    def location
      {
        allowed_attributes: %i[default multiselect],
        attribute_validations: {
          multiselect: { type: :boolean, allow_nil: true, default: false },
          default: { type: :string, allow_nil: true, default: nil }
        }
      }
    end

    def saveable
      {
        allowed_attributes: %i[default],
        attribute_validations: {
          default: { type: :boolean, allow_nil: true, default: false }
        }
      }
    end
  end
end
