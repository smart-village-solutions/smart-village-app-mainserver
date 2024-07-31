# frozen_string_literal: true

require "search_object/plugin/graphql"

class Resolvers::LunchesSearch < GraphQL::Schema::Resolver
  include SearchObject.module(:graphql)

  # TODO: hier fehlt ein Filter auf current User?
  scope { Lunch.upcoming }

  type types[Types::QueryTypes::LunchType]

  class LunchesOrder < ::Types::BaseEnum
    value "createdAt_DESC"
    value "createdAt_ASC"
    value "updatedAt_DESC"
    value "updatedAt_ASC"
    value "id_DESC"
    value "id_ASC"
  end

  option :date_range, type: types[GraphQL::Types::String], with: :apply_date_range
  option :limit, type: GraphQL::Types::Int, with: :apply_limit
  option :skip, type: GraphQL::Types::Int, with: :apply_skip
  option :ids, type: types[GraphQL::Types::ID], with: :apply_ids
  option :order, type: LunchesOrder, default: "createdAt_DESC"

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

  def apply_order_with_id_desc(scope)
    scope.order("id DESC")
  end

  def apply_order_with_id_asc(scope)
    scope.order("id ASC")
  end
end
