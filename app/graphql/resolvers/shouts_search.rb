# frozen_string_literal: true

require "search_object/plugin/graphql"

class Resolvers::ShoutsSearch < GraphQL::Schema::Resolver
  include SearchObject.module(:graphql)

  scope { GenericItem.upcoming(context[:current_user]) }

  type types[Types::QueryTypes::ShoutType]

  class ShoutOrder < ::Types::BaseEnum
    value "createdAt_DESC"
    value "createdAt_ASC"
    value "title_DESC"
    value "title_ASC"
  end

  option :order, type: ShoutOrder, default: "createdAt_DESC"

  def apply_order_with_created_at_desc(scope)
    scope.order("created_at DESC")
  end

  def apply_order_with_created_at_asc(scope)
    scope.order("created_at ASC")
  end

  def apply_order_with_title_desc(scope)
    scope.order("title DESC")
  end

  def apply_order_with_title_asc(scope)
    scope.order("title ASC")
  end
end
