# frozen_string_literal: true

module GlobalFilterScope
  extend ActiveSupport::Concern

  module ClassMethods
    # PointOfInterest.search("", { filter: [["municipality_id = '7'", "municipality_id = '6'"], ["location_district = 'Uckermark'", "location_district = 'Potsdam-Mittelmark'"]], hits_per_page: 1000 } ).pluck(:id)
    def global_record_ids
      global_record_ids = []
      current_municipality_id = MunicipalityService.municipality_id
      global_data_provider_ids = Array(
        Municipality.find(current_municipality_id).settings.dig(:activated_globals, :data_provider_ids)
      )

      # get global records for each global data provider
      global_data_provider_ids.each do |global_data_provider_id|
        global_data_provider = DataProvider.unscoped.where(id: global_data_provider_id).first
        next if global_data_provider.blank?

        # get global settings for resource: name == "Newsitem", "EventRecord", ...
        resource_settings = global_data_provider.settings(name)
        global_municipality_id = global_data_provider.municipality_id

        next if resource_settings.blank?

        global_settings = resource_settings.global_settings.fetch("municipality_#{current_municipality_id}", {})
        next unless global_settings["use_global_resource"] == "true"

        # Filter by municipality
        meili_filters = []
        meili_filters << "municipality_id = #{global_data_provider.municipality_id}"

        # Filter by location
        if const_defined?(:FILTERABLE_BY_LOCATION) &&
           self::FILTERABLE_BY_LOCATION == true
          # Muster
          # [ ["location_name = 'Havelland'", "location_name = 'Rügen'"], "municipality_id = 2" ]
          meili_filters << global_settings["filter_location_name"].map { |f| "location_name = '#{f}'" }
          meili_filters << global_settings["filter_location_region"].map { |f| "region_name = '#{f}'" }
          meili_filters << global_settings["filter_location_department"].map { |f| "location_department = '#{f}'" }
          meili_filters << global_settings["filter_location_district"].map { |f| "location_district = '#{f}'" }
          meili_filters << global_settings["filter_location_state"].map { |f| "location_state = '#{f}'" }
          meili_filters << global_settings["filter_location_country"].map { |f| "location_country = '#{f}'" }
        end

        # Filter by categories
        meili_filters << global_settings["filter_category_ids"].map do |f|
          category_name = Category.unscoped
                                  .where(municipality_id: global_municipality_id, id: f)
                                  .first
                                  .try(:name)
          "categories = '#{category_name}'"
        end

        # Perform search in Meilisearch
        meili_filters = meili_filters.compact.delete_if(&:blank?)
        begin
          searched_record_ids = search("*", filter: meili_filters, hits_per_page: MEILISEARCH_MAX_TOTAL_HITS).pluck(:id)
        rescue
          Rails.logger.error "Error in GlobalFilterScope.global_record_ids: #{e.message}"
          searched_record_ids = []
        end
        next if searched_record_ids.blank?

        global_record_ids << searched_record_ids
      end

      global_record_ids.flatten.compact.uniq.delete_if(&:blank?)
    end
  end

  included do
    # Filter by Search Results of Meilisearch
    # current scope is mapped to a list of record ids and then the scope is extended to include the global records
    scope :include_filtered_globals, lambda {
      # TODO: data_resources ids of all global municipalities e.g.: news_items, event_records, generic_items, ...
      record_ids = klass.global_record_ids
      return all if record_ids.blank?

      # upcomming.where(...).current_municipality...
      current_record_ids = all.pluck(:id)
      klass.unscoped.where(id: Array(current_record_ids + record_ids).flatten.compact.uniq)
    }
  end
end