# frozen_string_literal: true

require "search_object/plugin/graphql"
require "graphql/query_resolver"

class Resolvers::EventRecordsSearch
  include SearchObject.module(:graphql)

  scope { EventRecord.upcoming(context[:current_user]) }

  type types[Types::EventRecordType]

  class EventRecordsOrder < ::Types::BaseEnum
    value "createdAt_ASC"
    value "createdAt_DESC"
    value "updatedAt_ASC"
    value "updatedAt_DESC"
    value "title_ASC"
    value "title_DESC"
    value "id_ASC"
    value "id_DESC"
    value "listDate_DESC"
    value "listDate_ASC"
  end

  option :categoryId, type: types.ID, with: :apply_category_id
  option :skip, type: types.Int, with: :apply_skip
  option :limit, type: types.Int, with: :apply_limit
  option :take, type: types.Int, with: :apply_take
  option :order, type: EventRecordsOrder, default: "createdAt_DESC"
  option :dataProvider, type: types.String, with: :apply_data_provider
  option :dataProviderId, type: types.Int, with: :apply_data_provider_id

  def apply_category_id(scope, value)
    scope.with_category(value)
  rescue NoMethodError
    scope.select { |event_record| event_record.category_ids.include?(value.to_i) }
  end

  def apply_skip(scope, value)
    scope.offset(value)
  rescue NoMethodError
    scope.drop(value)
  end

  def apply_limit(scope, value)
    scope.limit(value)
  rescue NoMethodError
    scope.first(value)
  end

  def apply_take(scope, value)
    scope.take(value)
  end

  def apply_data_provider(scope, value)
    scope.joins(:data_provider).where(data_providers: { name: value })
  end

  def apply_data_provider_id(scope, value)
    scope.joins(:data_provider).where(data_providers: { id: value })
  end

  def apply_order_with_created_at_desc(scope)
    scope.order("created_at DESC")
  end

  def apply_order_with_created_at_asc(scope)
    scope.order("created_at ASC")
  end

  def apply_order_with_updated_at_desc(scope)
    scope.order("updated_at ASC")
  end

  def apply_order_with_updated_at_asc(scope)
    scope.order("updated_at ASC")
  end

  def apply_order_with_title_desc(scope)
    scope.order("title DESC")
  end

  def apply_order_with_title_asc(scope)
    scope.order("title ASC")
  end

  def apply_order_with_id_desc(scope)
    scope.order("id DESC")
  end

  def apply_order_with_id_asc(scope)
    scope.order("id ASC")
  end

  def apply_order_with_list_date_desc(scope)
    scope.sort_by(&:list_date).reverse
  end

  def apply_order_with_list_date_asc(scope)
    scope.sort_by(&:list_date)
  end

  # https://github.com/nettofarah/graphql-query-resolver

  def fetch_results
    # NOTE: Don't run QueryResolver during tests
    return super unless context.present?

    GraphQL::QueryResolver.run(EventRecord, context, Types::EventRecordType) do
      super
    end
  end
end
