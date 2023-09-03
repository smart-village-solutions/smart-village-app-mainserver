# frozen_string_literal: true

require "search_object/plugin/graphql"

class Resolvers::EventRecordsSearch < GraphQL::Schema::Resolver
  include SearchObject.module(:graphql)

  scope {
    event_records = EventRecord.upcoming(context[:current_user])

    begin
      lookahead = context[:extras][:lookahead].selection(:event_records)
      event_records = event_records.includes(:addresses) if lookahead.selects?(:addresses)
      event_records = event_records.includes(:categories) if lookahead.selects?(:categories)
      event_records = event_records.includes(:dates) if lookahead.selects?(:list_date) || lookahead.selects?(:dates)
      event_records = event_records.includes(:data_provider) if lookahead.selects?(:data_provider)
    rescue
      # ignore
    end

    event_records.distinct
  }

  type types[Types::QueryTypes::EventRecordType]

  class EventRecordsOrder < ::Types::BaseEnum
    value "createdAt_DESC"
    value "createdAt_ASC"
    value "updatedAt_DESC"
    value "updatedAt_ASC"
    value "id_DESC"
    value "id_ASC"
    value "title_DESC"
    value "title_ASC"
    value "listDate_DESC"
    value "listDate_ASC"
  end

  option :category_id, type: GraphQL::Types::ID, with: :apply_category_id
  option :skip, type: GraphQL::Types::Int, with: :apply_skip
  option :limit, type: GraphQL::Types::Int, with: :apply_limit
  option :ids, type: types[GraphQL::Types::ID], with: :apply_ids
  option :order, type: EventRecordsOrder, default: "createdAt_DESC"
  option :data_provider, type: GraphQL::Types::String, with: :apply_data_provider
  option :data_provider_id, type: GraphQL::Types::ID, with: :apply_data_provider_id
  option :take, type: GraphQL::Types::Int, with: :apply_take
  option :location, type: GraphQL::Types::String, with: :apply_location
  option :date_range, type: types[GraphQL::Types::String], with: :apply_date_range

  def apply_category_id(scope, value)
    scope.by_category(value)
  end

  def apply_skip(scope, value)
    scope.offset(value)
  end

  def apply_limit(scope, value)
    scope.limit(value)
  end

  def apply_ids(scope, value)
    scope.where(id: value)
  end

  # Achtung: Diese Methode liefert ein Array als Ergebnis
  # und kann nicht weiter verkettet werden
  def apply_take(scope, value)
    scope.take(value)
  end
  deprecate apply_take: :limit

  def apply_data_provider(scope, value)
    scope.joins(:data_provider).where(data_providers: { name: value })
  end

  def apply_data_provider_id(scope, value)
    scope.joins(:data_provider).where(data_providers: { id: value })
  end

  def apply_location(scope, value)
    scope.by_location(value)
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

  def apply_order_with_created_at_desc(scope)
    scope.order("event_records.created_at DESC")
  end

  def apply_order_with_created_at_asc(scope)
    scope.order("event_records.created_at ASC")
  end

  def apply_order_with_updated_at_desc(scope)
    scope.order("event_records.updated_at DESC")
  end

  def apply_order_with_updated_at_asc(scope)
    scope.order("event_records.updated_at ASC")
  end

  def apply_order_with_id_desc(scope)
    scope.order("event_records.id DESC")
  end

  def apply_order_with_id_asc(scope)
    scope.order("event_records.id ASC")
  end

  def apply_order_with_title_desc(scope)
    scope.order("event_records.title DESC")
  end

  def apply_order_with_title_asc(scope)
    scope.order("event_records.title ASC")
  end

  def apply_order_with_list_date_desc(scope)
    ordered_ids = scope.select(&:list_date).sort_by(&:list_date).reverse.map(&:id)

    scope.order_as_specified(id: ordered_ids)
  end

  def apply_order_with_list_date_asc(scope)
    ordered_ids = scope.select(&:list_date).sort_by(&:list_date).map(&:id)

    scope.order_as_specified(id: ordered_ids)
  end
end
