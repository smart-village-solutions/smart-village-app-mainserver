# frozen_string_literal: true

require "search_object/plugin/graphql"

class Resolvers::WeatherSearch < GraphQL::Schema::Resolver
  include SearchObject.module(:graphql)

  scope { OpenWeatherMap.all }

  type types[Types::QueryTypes::OpenWeatherMapType]

  class OpenWeatherMapsOrder < ::Types::BaseEnum
    value "createdAt_ASC"
    value "createdAt_DESC"
    value "id_ASC"
    value "id_DESC"
    value "updatedAt_ASC"
    value "updatedAt_DESC"
  end

  option :limit, type: GraphQL::Types::Int, with: :apply_limit
  option :skip, type: GraphQL::Types::Int, with: :apply_skip
  option :ids, type: types[GraphQL::Types::ID], with: :apply_ids
  option :order, type: OpenWeatherMapsOrder, default: "createdAt_DESC"

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
