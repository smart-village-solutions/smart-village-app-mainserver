# frozen_string_literal: true

require "search_object/plugin/graphql"
require "graphql/query_resolver"

class Resolvers::GenericItemSearch
  include SearchObject.module(:graphql)

  scope { GenericItem.filtered_for_current_user(context[:current_user]) }

  type types[Types::QueryTypes::GenericItemType]

  class GenericItemOrder < ::Types::BaseEnum
    value "createdAt_DESC"
    value "createdAt_ASC"
    value "updatedAt_DESC"
    value "updatedAt_ASC"
    value "publishedAt_DESC"
    value "publishedAt_ASC"
    value "publicationDate_DESC"
    value "publicationDate_ASC"
    value "id_DESC"
    value "id_ASC"
    value "title_DESC"
    value "title_ASC"
  end

  option :categoryId, type: types.ID, with: :apply_category_id
  option :categoryIds, type: types[types.ID], with: :apply_category_ids
  option :dataProvider, type: types.String, with: :apply_data_provider
  option :dataProviderId, type: types.ID, with: :apply_data_provider_id
  option :externalId, type: types.ID, with: :apply_external_id
  option :genericType, type: types.String, with: :apply_generic_type
  option :ids, type: types[types.ID], with: :apply_ids
  option :limit, type: types.Int, with: :apply_limit
  option :order, type: GenericItemOrder, default: "createdAt_DESC"
  option :skip, type: types.Int, with: :apply_skip
  option :location, type: types.String, with: :apply_location

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

  def apply_order_with_publication_date_desc(scope)
    scope.order("publication_date DESC")
  end

  def apply_order_with_publication_date_asc(scope)
    scope.order("publication_date ASC")
  end

  def apply_order_with_id_desc(scope)
    scope.order("id DESC")
  end

  def apply_order_with_id_asc(scope)
    scope.order("id ASC")
  end

  def apply_order_with_title_desc(scope)
    scope.order("title DESC")
  end

  def apply_order_with_title_asc(scope)
    scope.order("title ASC")
  end

  def apply_data_provider(scope, value)
    scope.joins(:data_provider).where(data_providers: { name: value })
  end

  def apply_data_provider_id(scope, value)
    scope.joins(:data_provider).where(data_providers: { id: value })
  end

  def apply_category_id(scope, value)
    scope.by_category(value)
  end
  alias_method :apply_category_ids, :apply_category_id

  def apply_generic_type(scope, value)
    scope.where(generic_type: value)
  end

  def apply_external_id(scope, value)
    scope.where(external_id: value)
  end

  def apply_location(scope, value)
    scope.by_location(value)
  end

  # https://github.com/nettofarah/graphql-query-resolver

  def fetch_results
    # NOTE: Don't run QueryResolver during tests
    return super unless context.present?

    GraphQL::QueryResolver.run(GenericItem, context, Types::QueryTypes::GenericItemType) do
      super
    end
  end
end
