# frozen_string_literal: true

require "search_object/plugin/graphql"

class Resolvers::GenericItemSearch < GraphQL::Schema::Resolver
  include SearchObject.module(:graphql)

  scope { GenericItem.filtered_for_current_user(context[:current_user]).include_filtered_globals }

  type types[Types::QueryTypes::GenericItemType]

  class GenericItemOrder < ::Types::BaseEnum
    value "createdAt_DESC"
    value "createdAt_ASC"
    value "updatedAt_DESC"
    value "updatedAt_ASC"
    value "publishedAt_DESC"
    value "publishedAt_ASC"
    value "publicationDate_DESC"
    value "publicationDate_ASC"
    value "id_DESC"
    value "id_ASC"
    value "title_DESC"
    value "title_ASC"
  end

  option :category_id, type: GraphQL::Types::ID, with: :apply_category_id
  option :category_ids, type: types[GraphQL::Types::ID], with: :apply_category_ids
  option :data_provider, type: GraphQL::Types::String, with: :apply_data_provider
  option :data_provider_id, type: GraphQL::Types::ID, with: :apply_data_provider_id
  option :external_id, type: GraphQL::Types::ID, with: :apply_external_id
  option :generic_type, type: GraphQL::Types::String, with: :apply_generic_type
  option :ids, type: types[GraphQL::Types::ID], with: :apply_ids
  option :limit, type: GraphQL::Types::Int, with: :apply_limit
  option :order, type: GenericItemOrder, default: "createdAt_DESC"
  option :skip, type: GraphQL::Types::Int, with: :apply_skip
  option :location, type: GraphQL::Types::String, with: :apply_location
  option :current_member, type: GraphQL::Types::Boolean, default: false, with: :apply_current_member
  option :member_id, type: GraphQL::Types::ID, with: :apply_member_id
  option :search, type: GraphQL::Types::String, with: :apply_search

  def apply_search(scope, value)
    search_ids = scope.search(value, filter: GlobalMeilisearchHelper.municipality_id_filters,
                                     hits_per_page: MEILISEARCH_MAX_TOTAL_HITS).pluck(:id)
    scope.where(id: search_ids)
  end

  # TODO: reihenfolge checken der MEthoden
  def apply_member_id(scope, value)
    return scope if value.blank?

    scope.where(member_id: value)
  end

  # filter all GenericItems by current_member authorized by auth_token
  def apply_current_member(scope, value)
    return scope unless value == true
    return scope if context[:current_member].blank?
    return scope if context[:current_member].try(:id).blank?

    scope.where(member_id: context[:current_member].try(:id))
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

  def apply_data_provider(scope, value)
    scope.joins(:data_provider).where(data_providers: { name: value })
  end

  def apply_data_provider_id(scope, value)
    scope.joins(:data_provider).where(data_providers: { id: value })
  end

  def apply_category_id(scope, value)
    scope.by_category(value)
  end
  alias_method :apply_category_ids, :apply_category_id

  def apply_generic_type(scope, value)
    scope.where(generic_type: value)
  end

  def apply_external_id(scope, value)
    scope.where(external_id: value)
  end

  def apply_location(scope, value)
    scope.by_location(value)
  end
end
