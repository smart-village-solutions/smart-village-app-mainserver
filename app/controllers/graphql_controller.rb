# frozen_string_literal: true

class GraphqlController < ApplicationController
  # To activate access control by doorkeeper, uncomment next line - comment to deactivate doorkeeper
  before_action :doorkeeper_authorize!

  skip_before_action :verify_authenticity_token

  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      # Query context goes here, for example:
      current_user: current_resource_owner,
      extras: { lookahead: GraphQL::Query.new(SmartVillageAppMainserverSchema, query).lookahead }

      # NOTE: if we want to have more data, we can add the `request` here, for example:
      # request: request
    }

    result = SmartVillageAppMainserverSchema.execute(
      query,
      variables: variables,
      context: context,
      operation_name: operation_name
    )

    log_graphql_execution_error(result, query)
    render json: result
  rescue StandardError => error
    raise error unless Rails.env.development?

    handle_error_in_development error
  end

  private

    def current_resource_owner
      owner_id = doorkeeper_token.try(:application).try(:owner_id) if doorkeeper_token
      User.find_by(id: owner_id) if owner_id.present?
    end

    def log_graphql_execution_error(result, query)
      result_hash = result.to_h
      if result_hash.key?("errors")
        error_hash = { GraphQLServerError: result_hash, payload: query }
        logger.error(error_hash)
      end
    end

    # Handle form data, JSON body, or a blank value
    def ensure_hash(ambiguous_param)
      case ambiguous_param
      when String
        if ambiguous_param.present?
          ensure_hash(JSON.parse(ambiguous_param))
        else
          {}
        end
      when Hash, ActionController::Parameters
        ambiguous_param
      when nil
        {}
      else
        raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
      end
    end

    def handle_error_in_development(err)
      logger.error err.message
      logger.error err.backtrace.join("\n")

      render json: { error: {
        message: err.message,
        backtrace: err.backtrace
      }, data: {} }, status: 500
    end
end
