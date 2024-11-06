# frozen_string_literal: true

require "search_object/plugin/graphql"
require "graphql/query_resolver"

class Resolvers::NewsItemsSearch
  include SearchObject.module(:graphql)

  description "Searches for news items"

  scope do
    includes = []

    begin
      lookahead = context[:extras][:lookahead].selection(:news_items)
      includes << :categories if lookahead.selects?(:categories)
      includes << :data_provider if lookahead.selects?(:data_provider)
      if lookahead.selects?(:address)
        includes << :address
        address_lookahead = lookahead.selection(:address)
        includes << { address: :geo_location } if address_lookahead.selects?(:geo_location)
      end
      if lookahead.selects?(:content_blocks)
        includes << :content_blocks
        content_block_lookahead = lookahead.selection(:content_blocks)
        if content_block_lookahead.selects?(:media_contents)
          includes << { content_blocks: :media_contents }
          media_content_lookahead = content_block_lookahead.selection(:media_contents)
          includes << { content_blocks: { media_contents: :source_url } } if media_content_lookahead.selects?(:source_url)
        end
      end
      includes << :source_url if lookahead.selects?(:source_url)
    rescue
      # ignore
    end

    NewsItem.filtered_for_current_user(context[:current_user]).includes(includes)
  end

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

  option :ids, type: types[types.ID], with: :apply_ids
  option :dataProvider, type: types.String, with: :apply_data_provider
  option :dataProviderId, type: types.ID, with: :apply_data_provider_id
  option :excludeDataProviderIds, type: types[types.ID], with: :apply_exclude_data_provider_ids
  option :excludeMowasRegionalKeys, type: types[types.String], with: :apply_exclude_mowas_regional_keys
  option :categoryId, type: types.ID, with: :apply_category_id
  option :categoryIds, type: types[types.ID], with: :apply_category_ids
  option :limit, type: types.Int, with: :apply_limit
  option :skip, type: types.Int, with: :apply_skip
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

  # https://github.com/nettofarah/graphql-query-resolver

  def fetch_results
    # NOTE: Don't run QueryResolver during tests
    return super unless context.present?

    GraphQL::QueryResolver.run(NewsItem, context, Types::QueryTypes::NewsItemType) do
      super
    end
  end
end
