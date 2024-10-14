# frozen_string_literal: true

require "search_object/plugin/graphql"

class Resolvers::CategoriesSearch < GraphQL::Schema::Resolver
  include SearchObject.module(:graphql)

  scope { Category.active }

  type types[Types::QueryTypes::CategoryType]

  class CategoriesOrder < ::Types::BaseEnum
    value "createdAt_DESC"
    value "createdAt_ASC"
    value "updatedAt_DESC"
    value "updatedAt_ASC"
    value "id_DESC"
    value "id_ASC"
    value "name_DESC"
    value "name_ASC"
    value "position_DESC"
    value "position_ASC"
  end

  class TaggingStrategy < Types::BaseEnum
    value "ANY", "Match any of the specified tags"
    value "ALL", "Match all given tags"
    value "EXCLUDE", "Match any that have not been tagged with the specified tags"
  end

  TAGGING_STRATEGIES = {
    "ANY" => { any: true },
    "ALL" => { match_all: true },
    "EXCLUDE" => { exclude: true }
  }.freeze

  option :limit, type: GraphQL::Types::Int, with: :apply_limit
  option :skip, type: GraphQL::Types::Int, with: :apply_skip
  option :ids, type: types[GraphQL::Types::ID], with: :apply_ids
  option :exclude_ids, type: types[GraphQL::Types::ID], with: :apply_exclude_ids
  option :tagging_strategy, type: TaggingStrategy, default: "ANY", with: :set_tagging_strategy
  option :tag_list, type: types[GraphQL::Types::String], with: :apply_tag_list
  option :order, type: [CategoriesOrder], default: ["name_ASC"], with: :apply_order

  def apply_limit(scope, value)
    scope.limit(value)
  end

  def apply_skip(scope, value)
    scope.offset(value)
  end

  def apply_ids(scope, value)
    scope.where(id: value)
  end

  def apply_exclude_ids(scope, value)
    scope.where.not(id: value)
  end

  def set_tagging_strategy(scope, value)
    @tagging_strategy = value
    scope
  end

  def apply_tag_list(scope, value)
    scope.tagged_with(value, TAGGING_STRATEGIES[@tagging_strategy])
  end

  def apply_order(scope, values)
    # secure that values is an array
    orders = Array.wrap(values)

    # values is list of string like ["name_ASC"]
    # CategoriesOrder.values are defined in the CategoriesOrder enum
    orders.each do |order_value|
      unless CategoriesOrder.values.keys.include?(order_value)
        raise GraphQL::ExecutionError, "Invalid sort option: #{order_value}"
      end
    end

    order_clauses = orders.map do |order_value|
      sort_field, sort_direction = order_value.split("_")
      sort_field = sort_field.underscore

      unless sort_field && %w[ASC DESC].include?(sort_direction)
        raise GraphQL::ExecutionError, "Invalid sort option: #{order_value}"
      end

      "#{sort_field} #{sort_direction}"
    end

    scope.order(order_clauses.join(", "))
  end

  def apply_orders(scope, _value)
    scope
  end
end
