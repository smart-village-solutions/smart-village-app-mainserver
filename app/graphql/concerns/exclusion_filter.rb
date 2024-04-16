# frozen_string_literal: true

# class comment
# rubocop:disable all
module ExclusionFilter
  extend ActiveSupport::Concern

  def exclusion_filter_for_klass(klass, scope, filter_json)
    criteria = JSON.parse(filter_json)
    filter_scopes = nil

    criteria.each do |category_ids, dp_poi_ids|
      category_ids = category_ids.to_s.split("_").map(&:to_i)

      with_descendant_ids = Category.where(id: category_ids).map(&:subtree_ids).flatten.uniq

      dp_ids, poi_ids = extract_ids_from_exclusions(dp_poi_ids)

      criteria_scope = klass.joins(:categories).where(categories: { id: with_descendant_ids }).by_data_provider_or_poi(dp_ids, poi_ids)

      filter_scopes = filter_scopes.nil? ? criteria_scope : filter_scopes.or(criteria_scope)
    end

    return scope if filter_scopes.nil?

    filter_condition_sql = filter_scopes.to_sql
    where_sql_condition = filter_condition_sql.downcase.split("where")[1]

    scope.joins(:categories).where.not(where_sql_condition)
  end

  private

    def extract_ids_from_exclusions(exclusions)
      data_provider_ids = exclusions.filter_map { |e| e.delete_prefix("dp_").to_i if e.start_with?("dp_") }
      poi_ids = exclusions.filter_map { |e| e.delete_prefix("poi_").to_i if e.start_with?("poi_") }
      [data_provider_ids, poi_ids]
    end
end
