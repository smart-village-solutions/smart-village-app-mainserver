# frozen_string_literal: true

# class comment
# rubocop:disable all
module ExclusionFilter
  extend ActiveSupport::Concern

  # This method allows us to prepare query for filtering out records based on exclusion criteria
  # It takes the following arguments:
  # - klass: the class of the model we want to filter
  # - scope: the current scope of the model(as an example current filtered or structured relation from resolver)
  # - filter_json: the json string that contains the exclusion criteria

  # Example of filter_json:
  # {
  #   "1": ["dp_1"],
  #   "2": ["poi_1"],
  #   "3_5": [],
  #   "4": ["dp_1", "poi_2"],
  #   "6_7": ["dp_1", "poi_2"]
  # }

  # Example of prepared where sql clause based on the above filter_json:
  # WHERE NOT (
  #   (categories.id IN (1) AND data_provider_id IN (1)) OR
  #   (categories.id IN (2) AND point_of_interest_id IN (1)) OR
  #   (categories.id IN (3, 5)) OR
  #   (categories.id IN (4) AND (data_provider_id IN (1) OR point_of_interest_id IN (2))) OR
  #   (categories.id IN (6, 7) AND (data_provider_id IN (1) OR point_of_interest_id IN (2)))
  # )

  def exclusion_filter_for_klass(klass, scope, filter_json)
    filter_json = JSON.parse(filter_json) if filter_json.is_a?(String)
    filter_json = filter_json.permit!.to_h if filter_json.is_a?(ActionController::Parameters)

    return scope if filter_json.blank?

    criteria = filter_json
    filter_scopes = nil

    criteria.each do |category_ids, dp_poi_ids|
      category_ids = category_ids.to_s.split("_").map(&:to_i)

      # subtree_ids is a method from ancestry gem, here we prepare an array of category ids including all descendants
      with_descendant_ids = Category.where(id: category_ids).map(&:subtree_ids).flatten.uniq

      # extract_ids_from_exclusions is a helper method to extract data provider and point of interest ids from exclusion criteria
      # it returns array of arrays, from left to right: [data_provider_ids, poi_ids]
      dp_ids, poi_ids = extract_ids_from_exclusions(dp_poi_ids)

      # by_data_provider_or_poi is a scope defined in FilterByDataProviderAndPoiScope concern
      # it uses two scopes inside it devided by OR operator
      # here we just prepare sql query and don't perform any requests
      criteria_scope = klass.where(categories: { id: with_descendant_ids }).by_data_provider_or_poi(dp_ids, poi_ids)

      # we use OR operator to combine all criteria scopes
      filter_scopes = filter_scopes.nil? ? criteria_scope : filter_scopes.or(criteria_scope)
    end

    return scope if filter_scopes.nil?

    # transform the prepared query to sql and extract the where clause from it
    filter_condition_sql = filter_scopes.to_sql
    where_sql_condition = filter_condition_sql.downcase.split("where")[1]

    # finally we apply the where clause to the current scope
    scope.joins(:categories).where.not(where_sql_condition)
  end

  private

    def extract_ids_from_exclusions(exclusions)
      data_provider_ids = exclusions.filter_map { |e| e.delete_prefix("dp_").to_i if e.start_with?("dp_") }
      poi_ids = exclusions.filter_map { |e| e.delete_prefix("poi_").to_i if e.start_with?("poi_") }
      [data_provider_ids, poi_ids]
    end
end
