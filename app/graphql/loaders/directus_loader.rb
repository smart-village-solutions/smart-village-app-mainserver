require "graphql/remote_loader"

# The gem handles most of the heavy lifting, but it's left up to the application
# to define how they query the remote GraphQL API.
#
# To use the gem, a loader needs to be defined that subclasses GraphQL::RemoteLoader::Loader
#
# This loader should define one public method, #query(query_string)
#
# #query takes a query string, queries the remote API, and returns the results.
# The returned value should be a hash or a type that responds to #to_h.
#
# This loader uses GraphQL::Client to query the remote API.
# DirectusClient is defined in config/application.rb
class DirectusLoader < GraphQL::RemoteLoader::Loader
  def query(query_string, context: {})
    return unless directus_defined?
    return if directus_client.nil?

    parsed_query = directus_client.parse(query_string)
    directus_client.query(parsed_query, variables: {}, context: {})
  end

  def directus_defined?
    Settings.directus[:graphql_endpoint].present?
  end

  # EXAMPLE FROM https://github.com/d12/graphql-remote_loader_example/blob/master/config/application.rb
  #
  # Defining the GraphQL::Client HTTP adapter and client that we use in query method
  def directus_client
    begin
      @directus_client ||= GraphQL::Client.new(
        schema: GraphQL::Client.load_schema(directus_http_adapter),
        execute: directus_http_adapter
      )
      @directus_client.allow_dynamic_queries = true

      return @directus_client
    rescue
      nil
    end
  end

  def directus_http_adapter
    graphql_endpoint = Settings.directus[:graphql_endpoint]
    return if graphql_endpoint.blank?

    GraphQL::Client::HTTP.new(graphql_endpoint) do
      def headers(_context)
        graphql_access_token = Settings.directus[:graphql_access_token]

        { "Authorization" => "Bearer #{graphql_access_token}" }
      end
    end
  end

end
