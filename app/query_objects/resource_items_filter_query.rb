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

    def apply_filter_criteria
      criteria = JSON.parse(@filter_json)
      conditions = []

      criteria.each do |category_ids, dp_poi_ids|
        category_ids = category_ids.to_s.split("_").map(&:to_i)

        with_descendant_ids = Category.where(id: category_ids).map(&:subtree_ids).flatten.uniq

        dp_ids, poi_ids = extract_ids_from_exclusions(dp_poi_ids)

        creteria_conditions = []
        arr = []
        creteria_conditions << ActiveRecord::Base.sanitize_sql_array(["categories.id IN(?)", with_descendant_ids])
        arr << ActiveRecord::Base.sanitize_sql_array(["(data_provider_id IN (?) AND data_provider_id IS NOT NULL)", dp_ids]) unless dp_ids.empty?
        arr << ActiveRecord::Base.sanitize_sql_array(["(point_of_interest_id IN (?) AND point_of_interest_id IS NOT NULL)", poi_ids]) unless poi_ids.empty?

        creteria_conditions << arr.join(" OR ") unless arr.empty?

        conditions << creteria_conditions.join(" AND ")
      end

      @scope.joins(:categories).where.not("(#{conditions.join(") OR (")})")
    end

    def extract_ids_from_exclusions(exclusions)
      data_provider_ids = exclusions.filter_map { |e| e.delete_prefix("dp_").to_i if e.start_with?("dp_") }
      poi_ids = exclusions.filter_map { |e| e.delete_prefix("poi_").to_i if e.start_with?("poi_") }
      [data_provider_ids, poi_ids]
    end
end
