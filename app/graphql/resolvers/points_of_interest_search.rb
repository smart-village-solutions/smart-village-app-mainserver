# frozen_string_literal: true

require "search_object/plugin/graphql"
require "graphql/query_resolver"

class Resolvers::PointsOfInterestSearch
  include SearchObject.module(:graphql)

  description "Searches for points of interest"

  scope do
    includes = []

    begin
      lookahead = context[:extras][:lookahead].selection(:points_of_interest)
      includes << :categories if lookahead.selects?(:categories)
      includes << :data_provider if lookahead.selects?(:data_provider)
      if lookahead.selects?(:media_contents)
        includes << :media_contents
        media_content_lookahead = lookahead.selection(:media_contents)
        includes << { media_contents: :source_url } if media_content_lookahead.selects?(:source_url)
      end
      if lookahead.selects?(:addresses)
        includes << :addresses
        address_lookahead = lookahead.selection(:addresses)
        includes << { addresses: :geo_location } if address_lookahead.selects?(:geo_location)
      end
      if lookahead.selects?(:contact)
        includes << :contact
        contact_lookahead = lookahead.selection(:contact)
        includes << { contact: :web_urls } if contact_lookahead.selects?(:web_urls)
      end
      includes << :web_urls if lookahead.selects?(:web_urls)
      includes << :price_informations if lookahead.selects?(:price_informations)
      includes << :opening_hours if lookahead.selects?(:opening_hours)
      if lookahead.selects?(:operating_company)
        includes << :operating_company
        operating_company_lookahead = lookahead.selection(:operating_company)
        includes << { operating_company: :address } if operating_company_lookahead.selects?(:address)

        if operating_company_lookahead.selects?(:contact)
          includes << { operating_company: :contact }
          operating_company_contact_lookahead = operating_company_lookahead.selection(:contact)

          if operating_company_contact_lookahead.selects?(:web_urls)
            includes << { operating_company: { contact: :web_urls } }
          end
        end
      end
      if lookahead.selects?(:location)
        includes << :location
        location_lookahead = lookahead.selection(:location)
        includes << { location: :geo_location } if location_lookahead.selects?(:geo_location)
      end
    rescue
      # ignore
    end

    PointOfInterest.filtered_for_current_user(context[:current_user]).includes(includes)
  end

  type types[Types::QueryTypes::PointOfInterestType]

  class PointsOfInterestOrder < ::Types::BaseEnum
    value "createdAt_DESC"
    value "createdAt_ASC"
    value "updatedAt_DESC"
    value "updatedAt_ASC"
    value "id_DESC"
    value "id_ASC"
    value "name_DESC"
    value "name_ASC"
    value "RAND"
  end

  option :limit, type: types.Int, with: :apply_limit
  option :skip, type: types.Int, with: :apply_skip
  option :ids, type: types[types.ID], with: :apply_ids
  option :order, type: PointsOfInterestOrder, default: "createdAt_DESC"
  option :dataProvider, type: types.String, with: :apply_data_provider
  option :dataProviderId, type: types.ID, with: :apply_data_provider_id
  option :category, type: types.String, with: :apply_category
  option :categoryId, type: types.ID, with: :apply_category_id
  option :categoryIds, type: types[types.ID], with: :apply_category_ids
  option :location, type: types.String, with: :apply_location

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

  def apply_data_provider(scope, value)
    scope.joins(:data_provider).where(data_providers: { name: value })
  end

  def apply_data_provider_id(scope, value)
    scope.joins(:data_provider).where(data_providers: { id: value })
  end

  def apply_category(scope, value)
    scope.joins(:categories).where(categories: { name: value })
  end

  def apply_category_id(scope, value)
    scope.by_category(value)
  end
  alias_method :apply_category_ids, :apply_category_id

  def apply_location(scope, value)
    scope.by_location(value)
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

  def apply_order_with_rand(scope)
    scope.order("RAND()")
  end

  # https://github.com/nettofarah/graphql-query-resolver

  def fetch_results
    # NOTE: Don't run QueryResolver during tests
    return super unless context.present?

    GraphQL::QueryResolver.run(PointOfInterest, context, Types::QueryTypes::PointOfInterestType) do
      super
    end
  end
end
