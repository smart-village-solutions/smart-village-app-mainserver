# frozen_string_literal: true

require "search_object/plugin/graphql"

class Resolvers::NewsItemsSearch < GraphQL::Schema::Resolver
  include SearchObject.module(:graphql)
  include ExclusionFilter
  include JsonFilterParseable

  scope { NewsItem.filtered_for_current_user(context[:current_user]).include_filtered_globals }

  type types[Types::QueryTypes::NewsItemType]

  class NewsItemsOrder < ::Types::BaseEnum
    value "createdAt_DESC"
    value "createdAt_ASC"
    value "updatedAt_DESC"
    value "updatedAt_ASC"
    value "publishedAt_DESC"
    value "publishedAt_ASC"
    value "id_DESC"
    value "id_ASC"
  end

  option :ids, type: types[GraphQL::Types::ID], with: :apply_ids
  option :data_provider, type: GraphQL::Types::String, with: :apply_data_provider
  option :data_provider_id, type: GraphQL::Types::ID, with: :apply_data_provider_id
  option :data_provider_ids, type: types[GraphQL::Types::ID], with: :apply_data_provider_id
  option :exclude_data_provider_ids, type: types[GraphQL::Types::ID], with: :apply_exclude_data_provider_ids
  option :exclude_mowas_regional_keys, type: types[GraphQL::Types::String], with: :apply_exclude_mowas_regional_keys
  option :category_id, type: GraphQL::Types::ID, with: :apply_category_id
  option :category_ids, type: types[GraphQL::Types::ID], with: :apply_category_ids
  option :date_range, type: types[GraphQL::Types::String], with: :apply_date_range
  option :exclude_filter, type: GraphQL::Types::JSON, with: :apply_exclude_filter
  option :search, type: GraphQL::Types::String, with: :apply_search
  option :limit, type: GraphQL::Types::Int, with: :apply_limit
  option :skip, type: GraphQL::Types::Int, with: :apply_skip
  option :order, type: NewsItemsOrder, default: "publishedAt_DESC"

  def apply_ids(scope, value)
    scope.where(id: value)
  end

  def apply_data_provider(scope, value)
    scope.joins(:data_provider).where(data_providers: { name: value })
  end

  def apply_data_provider_id(scope, value)
    scope.where(data_provider_id: value)
  end

  def apply_exclude_data_provider_ids(scope, value)
    scope.where.not(data_provider_id: value)
  end

  def apply_exclude_mowas_regional_keys(scope, value)
    regional_keys = value.delete_if(&:blank?)
    return scope if regional_keys.blank?

    news_items_with_regional_keys = scope.where("payload LIKE ?", "%regionalKeys%")

    # loop through all news items with regional keys and check if all of the regional keys are
    # present in the payload.regionalKeys object from the database. if this is the case, we can
    # safely exclude the news item from the result set.
    news_item_ids = news_items_with_regional_keys.select do |news_item|
      payload_regional_keys = news_item.payload[:regionalKeys]
      next if payload_regional_keys.blank?

      # if there is just one regional key for a message, we can check with include,
      # otherwise we need to check exactly if all regional keys from the payload are being excluded
      if payload_regional_keys.length == 1
        !regional_keys.include?(payload_regional_keys.first)
      else
        (regional_keys & payload_regional_keys).length != payload_regional_keys.length
      end
    end.pluck(:id)

    scope.where("news_items.payload IS NULL OR news_items.id IN (?)", news_item_ids)
  end

  def apply_category_id(scope, value)
    scope.by_category(value)
  end
  alias_method :apply_category_ids, :apply_category_id

  # filter_items method come from ExclusionFilter concern
  # parse_and_validate_filter_json method come from JsonFilterParseable concern and validate the JSON format
  def apply_exclude_filter(scope, filter_value)
    parsed_filter = parse_and_validate_filter_json(filter_value)
    exclusion_filter_for_klass(NewsItem, scope, parsed_filter)
  end

  def apply_search(scope, value)
    search_ids = scope.search(value, filter: GlobalMeilisearchHelper.municipality_id_filters,
                                     hits_per_page: MEILISEARCH_MAX_TOTAL_HITS).pluck(:id)
    scope.where(id: search_ids)
  end

  # :values is array of 2 dates:
  # - first element is :start_date
  # - second element is :end_date
  # Each element is of format "2020-12-31"
  def apply_date_range(scope, values)
    error_message = "DateRange invalid! Should be [start_date, end_date] each with format `2020-12-31`"
    raise error_message unless values.count == 2

    begin
      start_date = Date.parse(values[0])
      end_date = Date.parse(values[1])
    rescue ArgumentError
      raise error_message
    end

    scope.in_date_range(start_date, end_date)
  end

  def apply_limit(scope, value)
    scope.limit(value)
  end

  def apply_skip(scope, value)
    scope.offset(value)
  end

  def apply_order(scope, value)
    scope.order(value)
  end

  def apply_order_with_created_at_desc(scope)
    scope.order("created_at DESC")
  end

  def apply_order_with_created_at_asc(scope)
    scope.order("created_at ASC")
  end

  def apply_order_with_updated_at_desc(scope)
    scope.order("updated_at DESC")
  end

  def apply_order_with_updated_at_asc(scope)
    scope.order("updated_at ASC")
  end

  def apply_order_with_published_at_desc(scope)
    scope.order("published_at DESC")
  end

  def apply_order_with_published_at_asc(scope)
    scope.order("published_at ASC")
  end

  def apply_order_with_id_desc(scope)
    scope.order("id DESC")
  end

  def apply_order_with_id_asc(scope)
    scope.order("id ASC")
  end
end
