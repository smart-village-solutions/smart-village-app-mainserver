# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :generic_items, function: Resolvers::GenericItemSearch
    field :generic_item, QueryTypes::GenericItemType, null: false do
      argument :id, ID, required: true
    end

    field :weather_maps, function: Resolvers::WeatherSearch
    field :weather_map, QueryTypes::OpenWeatherMapType, null: false do
      argument :id, ID, required: false
    end

    field :points_of_interest, function: Resolvers::PointsOfInterestSearch
    field :point_of_interest, QueryTypes::PointOfInterestType, null: false do
      argument :id, ID, required: true
    end

    field :event_records, [QueryTypes::EventRecordType], function: Resolvers::EventRecordsSearch
    field :event_record, QueryTypes::EventRecordType, null: false do
      argument :id, ID, required: true
    end
    field :event_records_addresses, [QueryTypes::AddressType], null: false do
      description "Adresses for upcoming events"
    end

    field :news_items, function: Resolvers::NewsItemsSearch
    field :news_item, QueryTypes::NewsItemType, null: false do
      argument :id, ID, required: true
    end

    field :tours, [QueryTypes::TourType], function: Resolvers::ToursSearch
    field :tour, QueryTypes::TourType, null: false do
      argument :id, ID, required: true
    end

    field :categories, [QueryTypes::CategoryType], function: Resolvers::CategoriesSearch
    field :category_tree, GraphQL::Types::JSON, null: false

    field :waste_tours, [QueryTypes::WasteTourType], null: false
    field :waste_tour_dates, [QueryTypes::WastePickUpTimeType], null: false do
      argument :tour_id, ID, required: true
    end
    field :waste_addresses, [QueryTypes::AddressType], function: Resolvers::WasteLocationSearch
    field :waste_location_types, [QueryTypes::WasteLocationTypeType], null: false do
      argument :tour_id, ID, required: false
    end
    field :waste_location_type, QueryTypes::WasteLocationTypeType, null: false do
      argument :id, ID, required: true
    end

    field :public_html_files, [QueryTypes::PublicHtmlFileType], null: false
    field :public_html_file, QueryTypes::PublicHtmlFileType, null: false do
      argument :name, String, required: true
      argument :version, String, required: false
    end

    field :public_json_file, QueryTypes::PublicJsonFileType, null: false do
      argument :name, String, required: true
      argument :version, String, required: false
    end

    field :news_items_data_providers, [QueryTypes::DataProviderType], null: false do
      argument :category_id, ID, required: false
      argument :category_ids, [ID], required: false
    end

    field :survey_comments, [QueryTypes::SurveyComment], null: false do
      argument :survey_id, ID, required: false
    end

    field :lunches, [QueryTypes::LunchType], function: Resolvers::LunchesSearch
    field :lunch, QueryTypes::LunchType, null: false do
      argument :id, ID, required: true
    end

    field :surveys, [QueryTypes::SurveyPollType], function: Resolvers::SurveyPollsSearch

    def waste_tours
      Waste::Tour.all
    end

    def waste_tour_dates(tour_id:)
      Waste::PickUpTime.where(waste_tour_id: tour_id)
    end

    def weather_map(id: nil)
      return OpenWeatherMap.find_by(id: id) if id.present?

      latest_weather_map = OpenWeatherMap.last
      return latest_weather_map if latest_weather_map.present? && latest_weather_map.created_at > (Time.now - 1.hour)

      WeatherMapService.new.import
    end

    def survey_comments(survey_id: nil)
      comments = Survey::Comment.filtered_for_current_user(context[:current_user])

      return comments.where(survey_poll_id: survey_id) if survey_id.present?

      comments
    end

    def point_of_interest(id:)
      PointOfInterest.find_by(id: id)
    end

    def event_record(id:)
      EventRecord.find_by(id: id)
    end

    def event_records_addresses
      upcoming_event_ids = EventRecord.upcoming(context[:current_user]).pluck(:id)

      Address.joins("
        INNER JOIN event_records ON event_records.id = addresses.addressable_id
        AND addresses.addressable_type = 'EventRecord'
      ").where(event_records: { id: upcoming_event_ids })
    end

    def news_item(id:)
      NewsItem.find_by(id: id)
    end

    def generic_item(id:)
      GenericItem.find(id)
    end

    def tour(id:)
      Tour.find_by(id: id)
    end

    def category_tree
      Category.order(:name).select(:id, :name, :ancestry).arrange_serializable
    end

    def waste_location_types(tour_id: nil)
      waste_location_types = Waste::LocationType.all
      waste_location_types = waste_location_types.where(waste_tour_id: tour_id) if tour_id.present?

      waste_location_types
    end

    def waste_location_type(id:)
      Waste::LocationType.find(id)
    end

    def news_items_data_providers(category_id: nil, category_ids: nil)
      if category_id.blank? && category_ids.blank?
        return DataProvider.joins(:news_items).order(:name).uniq
      end

      NewsItem
        .by_category(category_id || category_ids)
        .includes(:data_provider)
        .map(&:data_provider)
        .sort_by do |data_provider|
        data_provider.name.downcase
      end.uniq
    end

    def lunch(id:)
      Lunch.find_by(id: id)
    end

    def public_html_files
      StaticContent.where(data_type: "html").order(:name)
    end

    # Provide contents from html files in `public/mobile-app/contents` through GraphQL query
    #
    # @param [String] name the file name
    # @param [String] version an optional requested version number
    #
    # @return [Object] object with the contents of the file, if it exists - otherwise with ""
    def public_html_file(name:, version: nil)
      static_content_with_data_type("html", name, version)
    end

    # Provide contents from json files in `public/mobile-app/configs` through GraphQL query
    #
    # @param [String] name the file name
    # @param [String] version an optional requested version number
    #
    # @return [Object] object with the contents of the file, if it exists - otherwise with {}
    def public_json_file(name:, version: nil)
      static_content_with_data_type("json", name, version)
    end

    private

      # Provide a list of files within a folder that are whitelisted to be queried by the
      # GraphQL Server
      #
      # @param [String] path the path to lookup
      # @param [String] file_type the file type to lookup
      #
      # @return [Array] list of queryable files
      def query_files_whitelist(path, file_type)
        queryable_files = File.join(path, "*.#{file_type}")
        Dir.glob(queryable_files)
      end

      # Is a file allowed to be queried by the GraphQL server or not?
      #
      # @param [String] file the file to be queried
      # @param [String] path the path to lookup
      # @param [String] file_type the file type to lookup
      #
      # @return [Boolean] true, if file is existing and included in the whitelist - otherwise false
      def query_file?(file, path, file_type)
        File.exist?(file) && query_files_whitelist(path, file_type).include?(file)
      end

      def static_content_with_data_type(data_type, name, version = nil)
        static_contents = StaticContent.where(data_type: data_type, name: name)
        static_content = find_static_content(static_contents, name, version)

        # fallback for old app versions, that does not send versions, thus handle responses as
        # string and parses on mobile
        if version.nil?
          return static_content if static_content.present?

          return { content: data_type == "html" ? "" : {}, name: "not found" }
        end

        if static_content.blank?
          return { content: data_type == "html" ? "" : {}, name: "not found" }
        end

        return static_content if data_type == "html"

        begin
          return static_content.as_json.merge(content: JSON.parse(static_content.content))
        rescue JSON::ParserError
          return static_content
        end
      end

      # loop through static contents for a queried name and optionally queried version
      #
      # @param [Array] static_contents all entries to loop through
      # @param [String] query_name the content name that was queried
      # @param [String] query_version an optional content version number that was queried
      #
      # @return [Object] a (closest) versioned or an unversioned static content
      def find_static_content(static_contents, query_name, query_version = nil)
        max_version = nil # refers to 0.0.0 with Gem::Version
        versioned_static_content = nil
        unversioned_static_content = nil

        static_contents.each do |static_content|
          if static_content.version.blank?
            unversioned_static_content = static_content
            next
          end

          version = static_content.version

          next unless Gem::Version.new(max_version) < Gem::Version.new(version) &&
                      Gem::Version.new(version) <= Gem::Version.new(query_version)

          max_version = version
          versioned_static_content = static_content
        end

        return versioned_static_content if versioned_static_content

        unversioned_static_content
      rescue StandardError
        nil
      end
  end
end
