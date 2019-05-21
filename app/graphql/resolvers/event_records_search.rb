# frozen_string_literal: true

require "search_object/plugin/graphql"
require "graphql/query_resolver"
class Resolvers::EventRecordsSearch
  include SearchObject.module(:graphql)

  scope { EventRecord.all }

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
  end

  option :limit, type: types.Int, with: :apply_limit
  option :skip, type: types.Int, with: :apply_skip
  option :order, type: EventRecordsOrder, default: "createdAt_DESC"

  def apply_limit(scope, value)
    scope.limit(value)
  end

  def apply_skip(scope, value)
    scope.offset(value)
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

  # https://github.com/nettofarah/graphql-query-resolver

  def fetch_results
    # NOTE: Don't run QueryResolver during tests
    return super unless context.present?

    GraphQL::QueryResolver.run(EventRecord, context, Types::EventRecordType) do
      super
    end
  end
end
