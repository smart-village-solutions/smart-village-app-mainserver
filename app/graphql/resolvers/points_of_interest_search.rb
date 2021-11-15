# frozen_string_literal: true

require "search_object/plugin/graphql"
require "graphql/query_resolver"

class Resolvers::PointsOfInterestSearch
  include SearchObject.module(:graphql)

  scope { PointOfInterest.filtered_for_current_user(context[:current_user]) }

  type types[Types::QueryTypes::PointOfInterestType]

  class PointsOfInterestOrder < ::Types::BaseEnum
    value "createdAt_ASC"
    value "createdAt_DESC"
    value "id_ASC"
    value "id_DESC"
    value "name_ASC"
    value "name_DESC"
    value "RAND"
    value "updatedAt_ASC"
    value "updatedAt_DESC"
  end

  option :limit, type: types.Int, with: :apply_limit
  option :skip, type: types.Int, with: :apply_skip
  option :ids, type: types[types.ID], with: :apply_ids
  option :order, type: PointsOfInterestOrder, default: "createdAt_DESC"
  option :dataProvider, type: types.String, with: :apply_data_provider
  option :dataProviderId, type: types.ID, with: :apply_data_provider_id
  option :category, type: types.String, with: :apply_category
  option :categoryId, type: types.ID, with: :apply_category_id

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
    scope.with_category(value)
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

  def apply_order_with_name_desc(scope)
    scope.order("name DESC")
  end

  def apply_order_with_name_asc(scope)
    scope.order("name ASC")
  end

  def apply_order_with_id_desc(scope)
    scope.order("id DESC")
  end

  def apply_order_with_id_asc(scope)
    scope.order("id ASC")
  end

  def apply_order_with_rand(scope)
    scope.order("RAND()")
  end

  # https://github.com/nettofarah/graphql-query-resolver

  def fetch_results
    # NOTE: Don't run QueryResolver during tests
    return super unless context.present?

    GraphQL::QueryResolver.run(PointOfInterest, context, Types::QueryTypes::PointOfInterestType) do
      super
    end
  end
end
