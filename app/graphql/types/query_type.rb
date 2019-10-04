# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :points_of_interest, function: Resolvers::PointsOfInterestSearch
    field :point_of_interest, PointOfInterestType, null: false do
      argument :id, ID, required: true
    end

    field :event_records, function: Resolvers::EventRecordsSearch
    field :event_record, EventRecordType, null: false do
      argument :id, ID, required: true
    end

    field :news_items, function: Resolvers::NewsItemsSearch
    field :news_item, NewsItemType, null: false do
      argument :id, ID, required: true
    end

    field :tours, [TourType], function: Resolvers::ToursSearch
    field :tour, TourType, null: false do
      argument :id, ID, required: true
    end

    field :public_html_file, PublicHtmlFileType, null: false do
      argument :name, String, required: true
    end

    field :public_json_file, PublicJsonFileType, null: false do
      argument :name, String, required: true
    end

    field :categories, [CategoryType], null: false

    def point_of_interest(id:)
      PointOfInterest.find(id)
    end

    def event_record(id:)
      EventRecord.find(id)
    end

    def news_item(id:)
      NewsItem.find(id)
    end

    def tour(id:)
      Tour.find(id)
    end

    def categories
      Category.all.order(:name)
    end

    # Provide contents from html files in `public/mobile-app/contents` through GraphQL query
    #
    # @param [String] name the file name
    #
    # @return [Object] object with the contents of the file, if it exists - otherwise with ""
    def public_html_file(name:)
      static_content = StaticContent.where(name: name, data_type: "html").first
      return { content: static_content.content, name: name } if static_content.present?

      { content: "", name: "not found" }
    end

    # Provide contents from json files in `public/mobile-app/configs` through GraphQL query
    #
    # @param [String] name the file name
    #
    # @return [Object] object with the contents of the file, if it exists - otherwise with {}
    def public_json_file(name:)
      static_content = StaticContent.where(name: name, data_type: "json").first
      return { content: static_content.content, name: name } if static_content.present?

      { content: {}, name: "not found" }
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
  end
end
