# frozen_string_literal: true

require "search_object/plugin/graphql"

class Resolvers::EventRecordsSearch < GraphQL::Schema::Resolver
  include SearchObject.module(:graphql)
  include ExclusionFilter
  include JsonFilterParseable

  description "Searches for event records"

  scope do
    includes = []

    begin
      lookahead = context[:extras][:lookahead].selection(:event_records)
      includes << :active_categories if lookahead.selects?(:categories)
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
      if lookahead.selects?(:contacts)
        includes << :contacts
        contact_lookahead = lookahead.selection(:contacts)
        includes << { contacts: :web_urls } if contact_lookahead.selects?(:web_urls)
      end
      includes << :urls if lookahead.selects?(:urls)
      includes << :price_informations if lookahead.selects?(:price_informations)
      if lookahead.selects?(:organizer)
        includes << :organizer
        organizer_lookahead = lookahead.selection(:organizer)
        includes << { organizer: :address } if organizer_lookahead.selects?(:address)

        if organizer_lookahead.selects?(:contact)
          includes << { organizer: :contact }
          organizer_contact_lookahead = organizer_lookahead.selection(:contact)

          if organizer_contact_lookahead.selects?(:web_urls)
            includes << { organizer: { contact: :web_urls } }
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

    event_records = EventRecord.upcoming(context[:current_user]).include_filtered_globals.upcoming.includes(includes)

    # if the date is requested we need to return all records, because there will be different events
    # with the same id that only differ in date
    if lookahead.selects?(:date)
      event_records.upcoming_with_date_select
    else
      event_records.distinct
    end
  end

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

  option :search, type: GraphQL::Types::String, with: :apply_search
  option :category_id, type: GraphQL::Types::ID, with: :apply_category_id
  option :skip, type: GraphQL::Types::Int, with: :apply_skip
  option :limit, type: GraphQL::Types::Int, with: :apply_limit
  option :ids, type: types[GraphQL::Types::ID], with: :apply_ids
  option :order, type: EventRecordsOrder, default: "createdAt_DESC"
  option :data_provider, type: GraphQL::Types::String, with: :apply_data_provider
  option :data_provider_id, type: GraphQL::Types::ID, with: :apply_data_provider_id
  option :location, type: GraphQL::Types::String, with: :apply_location
  option :locations, type: types[GraphQL::Types::String], with: :apply_location
  option :exclude_filter, type: GraphQL::Types::JSON, with: :apply_exclude_filter
  option :date_range, type: types[GraphQL::Types::String], with: :apply_date_range
  option :take, type: GraphQL::Types::Int, with: :apply_take

  def apply_search(scope, value)
    search_ids = scope.search(value, filter: GlobalMeilisearchHelper.municipality_id_filters,
                                     hits_per_page: MEILISEARCH_MAX_TOTAL_HITS).pluck(:id)
    scope.where(id: search_ids)
  end

  def apply_category_id(scope, value)
    scope.by_category(value)
  end

  def apply_skip(scope, value)
    # HINT: if there is a date range, offset will be applied later
    scope.offset(value) unless params["date_range"]
  end

  def apply_limit(scope, value)
    scope.limit(value)
  end

  def apply_ids(scope, value)
    scope.where(id: value)
  end

  def apply_data_provider(scope, value)
    scope.joins(:data_provider).where(data_providers: { name: value })
  end

  def apply_data_provider_id(scope, value)
    scope.joins(:data_provider).where(data_providers: { id: value })
  end

  def apply_location(scope, value)
    scope.by_location(value)
  end

  # filter_items method come from ExclusionFilter concern
  # parse_and_validate_filter_json method come from JsonFilterParseable concern and validate the JSON format
  def apply_exclude_filter(scope, filter_value)
    parsed_filter = parse_and_validate_filter_json(filter_value)
    exclusion_filter_for_klass(EventRecord, scope, parsed_filter)
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

    # the date range filter gets applied after the order so we need to order again in some cases
    scope.in_date_range(start_date, end_date, params["order"], params["skip"])
  end

  # Achtung: Diese Methode liefert ein Array als Ergebnis
  # und kann nicht weiter verkettet werden
  def apply_take(scope, value)
    scope.take(value)
  end
  deprecate apply_take: :limit

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
