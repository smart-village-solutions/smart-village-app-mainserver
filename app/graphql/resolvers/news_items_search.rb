# frozen_string_literal: true

require "search_object/plugin/graphql"

class Resolvers::NewsItemsSearch < GraphQL::Schema::Resolver
  include SearchObject.module(:graphql)
  include ExclusionFilter
  include JsonFilterParseable

  scope { NewsItem.filtered_for_current_user(context[:current_user]) }

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

  option :limit, type: GraphQL::Types::Int, with: :apply_limit
  option :skip, type: GraphQL::Types::Int, with: :apply_skip
  option :ids, type: types[GraphQL::Types::ID], with: :apply_ids
  option :order, type: NewsItemsOrder, default: "publishedAt_DESC"
  option :data_provider, type: GraphQL::Types::String, with: :apply_data_provider
  option :data_provider_id, type: GraphQL::Types::ID, with: :apply_data_provider_id
  option :exclude_data_provider_ids, type: types[GraphQL::Types::ID], with: :apply_exclude_data_provider_ids
  option :exclude_mowas_regional_keys, type: types[GraphQL::Types::String], with: :apply_exclude_mowas_regional_keys
  option :category_id, type: GraphQL::Types::ID, with: :apply_category_id
  option :category_ids, type: types[GraphQL::Types::ID], with: :apply_category_ids
  option :exclude_filter, type: GraphQL::Types::JSON, with: :apply_exclude_filter

  def apply_limit(scope, value)
    scope.limit(value)
  end

  def apply_skip(scope, value)
    scope.offset(value)
  end

  def apply_ids(scope, value)
    scope.where(id: value)
  end

  def apply_order(scope, value)
    scope.order(value)
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
    value.each do |regional_key|
      next if regional_key.blank?

      scope = scope.where(
        "payload IS NULL OR (payload LIKE ? AND payload NOT LIKE ?)",
        "%regionalKeys%",
        "%#{regional_key}%"
      )
    end

    scope
  end

  def apply_category_id(scope, value)
    scope.by_category(value)
  end
  alias_method :apply_category_ids, :apply_category_id

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

  # filter_items method come from ExclusionFilter concern
  # parse_and_validate_filter_json method come from JsonFilterParseable concern and validate the JSON format
  def apply_exclude_filter(scope, filter_value)
    parsed_filter = parse_and_validate_filter_json(filter_value)
    exclusion_filter_for_klass(NewsItem, scope, parsed_filter)
  end
end
