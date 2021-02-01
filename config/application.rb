# frozen_string_literal: true

require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

require "graphql/client/http"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SmartVillageAppMainserver
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.autoload_paths += Dir[Rails.root.join("app", "models", "{**/*}")]
    # config.autoload_paths += Dir[Rails.root.join("app", "models", "{*/}")]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.i18n.available_locales = %i[de en]
  end

  # EXAMPLE FROM https://github.com/d12/graphql-remote_loader_example/blob/master/config/application.rb
  #
  # Defining the GraphQL::Client HTTP adapter and client that we use in app/graphql/loader/directus_loader.rb
  # This can be swapped out with any other way of querying a remote GraphQL API.
  graphql_endpoint = Rails.application.credentials.dig(:directus, :graphql_endpoint)

  if graphql_endpoint
    DirectusHTTPAdapter = GraphQL::Client::HTTP.new(graphql_endpoint) do
      def headers(_context)
        graphql_access_token = Rails.application.credentials.dig(:directus, :graphql_access_token)

        {
          "Authorization" => "Bearer #{graphql_access_token}"
        }
      end
    end

    ::DirectusClient = GraphQL::Client.new(
      schema: GraphQL::Client.load_schema(SmartVillageAppMainserver::DirectusHTTPAdapter),
      execute: SmartVillageAppMainserver::DirectusHTTPAdapter
    )

    DirectusClient.allow_dynamic_queries = true
  end
end
