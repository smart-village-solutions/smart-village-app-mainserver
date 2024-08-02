# frozen_string_literal: true

require "search_object/plugin/graphql"

class Resolvers::PointsOfInterestSearch < GraphQL::Schema::Resolver
  include SearchObject.module(:graphql)

  scope { PointOfInterest.filtered_for_current_user(context[:current_user]).include_filtered_globals }

  type types[Types::QueryTypes::PointOfInterestType]

  class PointsOfInterestOrder < ::Types::BaseEnum
    value "createdAt_DESC"
    value "createdAt_ASC"
    value "updatedAt_DESC"
    value "updatedAt_ASC"
    value "id_DESC"
    value "id_ASC"
    value "name_DESC"
    value "name_ASC"
    value "RAND"
  end

  option :limit, type: GraphQL::Types::Int, with: :apply_limit
  option :skip, type: GraphQL::Types::Int, with: :apply_skip
  option :ids, type: types[GraphQL::Types::ID], with: :apply_ids
  option :order, type: PointsOfInterestOrder, default: "createdAt_DESC"
  option :data_provider, type: GraphQL::Types::String, with: :apply_data_provider
  option :data_provider_id, type: GraphQL::Types::ID, with: :apply_data_provider_id
  option :category, type: GraphQL::Types::String, with: :apply_category
  option :category_id, type: GraphQL::Types::ID, with: :apply_category_id
  option :category_ids, type: types[GraphQL::Types::ID], with: :apply_category_ids
  option :location, type: GraphQL::Types::String, with: :apply_location
  option :search, type: GraphQL::Types::String, with: :apply_search

  def apply_search(scope, value)
    search_ids = scope.search(value, filter: GlobalMeilisearchHelper.municipality_id_filters,
                                     hits_per_page: MEILISEARCH_MAX_TOTAL_HITS).pluck(:id)
    scope.where(id: search_ids)
  end

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
    scope.joins(:data_provider).where(data_providers: { id: value })
  end

  def apply_category(scope, value)
    scope.joins(:categories).where(categories: { name: value })
  end

  def apply_category_id(scope, value)
    scope.by_category(value)
  end
  alias_method :apply_category_ids, :apply_category_id

  def apply_location(scope, value)
    scope.by_location(value)
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

  def apply_order_with_id_desc(scope)
    scope.order("id DESC")
  end

  def apply_order_with_id_asc(scope)
    scope.order("id ASC")
  end

  def apply_order_with_name_desc(scope)
    scope.order("name DESC")
  end

  def apply_order_with_name_asc(scope)
    scope.order("name ASC")
  end

  def apply_order_with_rand(scope)
    scope.order("RAND()")
  end
end
