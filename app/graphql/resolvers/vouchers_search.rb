# frozen_string_literal: true

require "search_object/plugin/graphql"

class Resolvers::VouchersSearch < GraphQL::Schema::Resolver
  include SearchObject.module(:graphql)

  scope { GenericItem.where(generic_type: "Voucher") }

  type types[Types::QueryTypes::GenericItemType]

  option :category_id, type: GraphQL::Types::ID, with: :apply_category_id
  option :data_provider, type: GraphQL::Types::String, with: :apply_data_provider
  option :data_provider_id, type: GraphQL::Types::ID, with: :apply_data_provider_id
  option :external_id, type: GraphQL::Types::ID, with: :apply_external_id
  option :generic_type, type: GraphQL::Types::String, with: :apply_generic_type
  option :ids, type: types[GraphQL::Types::ID], with: :apply_ids
  option :limit, type: GraphQL::Types::Int, with: :apply_limit
  option :order, type: Resolvers::GenericItemSearch::GenericItemOrder, default: "createdAt_DESC"
  option :skip, type: GraphQL::Types::Int, with: :apply_skip
  option :location, type: GraphQL::Types::String, with: :apply_location

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

  def apply_order_with_published_at_desc(scope)
    scope.order("published_at DESC")
  end

  def apply_order_with_published_at_asc(scope)
    scope.order("published_at ASC")
  end

  def apply_order_with_publication_date_desc(scope)
    scope.order("publication_date DESC")
  end

  def apply_order_with_publication_date_asc(scope)
    scope.order("publication_date ASC")
  end

  def apply_order_with_id_desc(scope)
    scope.order("id DESC")
  end

  def apply_order_with_id_asc(scope)
    scope.order("id ASC")
  end

  def apply_order_with_title_desc(scope)
    scope.order("title DESC")
  end

  def apply_order_with_title_asc(scope)
    scope.order("title ASC")
  end
end
