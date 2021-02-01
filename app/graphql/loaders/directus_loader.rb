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
    return unless defined?(DirectusClient)

    parsed_query = DirectusClient.parse(query_string)
    DirectusClient.query(parsed_query, variables: {}, context: {})
  end
end
