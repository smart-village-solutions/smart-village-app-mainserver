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
  option :order, type: CategoriesOrder, default: "name_ASC", with: :apply_order

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

  def apply_order(scope, value)
    # value is a string like "name_ASC"
    # CategoriesOrder.values are defined in the CategoriesOrder enum
    raise GraphQL::ExecutionError, "Ungültige Sortieroption" unless CategoriesOrder.values[value].present?

    # value is a string like "name_ASC" or "position_DESC"
    sort_field, sort_direction = value.split("_")
    unless sort_field && %w[ASC DESC].include?(sort_direction)
      raise GraphQL::ExecutionError, "Ungültige Sortieroptionen"
    end

    # sort by single order option
    scope.order("#{sort_field} #{sort_direction}")
  end

  def apply_orders(scope, _value)
    scope
  end
end
