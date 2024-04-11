# frozen_string_literal: true

# Class for filtering resource items by provided json filter
class ResourceItemsFilterQuery
  def initialize(scope, filter_json)
    @scope = scope
    @filter_json = filter_json
  end

  def call
    return @scope unless valid_filter_json? || needed_associations?

    apply_filter_criteria
  end

  private

    def valid_filter_json?
      JSON.parse(@filter_json)
      true
    rescue JSON::ParserError
      false
    end

    def needed_associations?
      klass = @scope.klass
      klass.reflect_on_association(:categories).present? &&
        klass.reflect_on_association(:data_provider).present? &&
        klass.reflect_on_association(:point_of_interest).present?
    end

    # This method is responsible for applying the filter criteria
    # to the scope. It returns the scope with the applied filter
    def apply_filter_criteria
      criteria = JSON.parse(@filter_json)
      conditions = []

      criteria.each do |category_ids, dp_poi_ids|
        category_ids = category_ids.to_s.split("_").map(&:to_i)

        # Select all categories with their children
        with_descendant_ids = Category.where(id: category_ids).map(&:subtree_ids).flatten.uniq

        next if with_descendant_ids.empty?

        dp_ids, poi_ids = extract_ids_from_exclusions(dp_poi_ids)

        creteria_conditions = []
        additional_filter = []

        # Prepare filter by categories ids
        creteria_conditions << "categories.id IN(#{with_descendant_ids.join(",")})"

        # Add additional filter by data provider or point of interest if ids present
        additional_filter << "(data_provider_id IN (#{dp_ids.join(",")}) AND data_provider_id IS NOT NULL)" unless dp_ids.empty?
        additional_filter << "(point_of_interest_id IN (#{poi_ids.join(",")}) AND point_of_interest_id IS NOT NULL)" unless poi_ids.empty?

        # Add OR betweeen additional filters
        creteria_conditions << additional_filter.join(" OR ") unless additional_filter.empty?

        # Join categories conditions with additional filters by AND
        conditions << creteria_conditions.join(" AND ")
      end

      return @scope if conditions.empty?

      # Join all conditions by OR
      @scope.joins(:categories).where.not(conditions.join(" OR "))
    end

    def extract_ids_from_exclusions(exclusions)
      data_provider_ids = exclusions.filter_map { |e| e.delete_prefix("dp_").to_i if e.start_with?("dp_") }
      poi_ids = exclusions.filter_map { |e| e.delete_prefix("poi_").to_i if e.start_with?("poi_") }
      [data_provider_ids, poi_ids]
    end
end
