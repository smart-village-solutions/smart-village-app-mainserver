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
  option :order, type: CategoriesOrder, default: "name_ASC"

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

  def apply_order_with_name_desc(scope)
    scope.order("name DESC")
  end

  def apply_order_with_name_asc(scope)
    scope.order("name ASC")
  end

  def apply_order_with_position_desc(scope)
    scope.order("position DESC")
  end

  def apply_order_with_position_asc(scope)
    scope.order("position ASC")
  end
end
