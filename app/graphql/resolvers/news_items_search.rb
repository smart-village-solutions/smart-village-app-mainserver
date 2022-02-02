# frozen_string_literal: true

require "search_object/plugin/graphql"
require "graphql/query_resolver"

class Resolvers::NewsItemsSearch
  include SearchObject.module(:graphql)

  scope { NewsItem.filtered_for_current_user(context[:current_user]) }

  type types[Types::QueryTypes::NewsItemType]

  class NewsItemsOrder < ::Types::BaseEnum
    value "createdAt_ASC"
    value "createdAt_DESC"
    value "id_ASC"
    value "id_DESC"
    value "publishedAt_ASC"
    value "publishedAt_DESC"
    value "updatedAt_ASC"
    value "updatedAt_DESC"
  end

  option :limit, type: types.Int, with: :apply_limit
  option :skip, type: types.Int, with: :apply_skip
  option :ids, type: types[types.ID], with: :apply_ids
  option :order, type: NewsItemsOrder, default: "publishedAt_DESC"
  option :dataProvider, type: types.String, with: :apply_data_provider
  option :dataProviderId, type: types.ID, with: :apply_data_provider_id
  option :excludeDataProviderIds, type: types[types.ID], with: :apply_exclude_data_provider_ids
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
    scope.where(data_provider_id: value)
  end

  def apply_exclude_data_provider_ids(scope, value)
    scope.where.not(data_provider_id: value)
  end

  def apply_category_id(scope, value)
    scope.by_category(value)
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

  # https://github.com/nettofarah/graphql-query-resolver

  def fetch_results
    # NOTE: Don't run QueryResolver during tests
    return super unless context.present?

    GraphQL::QueryResolver.run(NewsItem, context, Types::QueryTypes::NewsItemType) do
      super
    end
  end
end
