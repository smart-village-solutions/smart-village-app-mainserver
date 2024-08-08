# frozen_string_literal: true

class GraphqlController < ApplicationController
  # To activate access control by doorkeeper, uncomment next line - comment to deactivate doorkeeper
  before_action :doorkeeper_authorize!
  before_action :member_by_token

  skip_before_action :verify_authenticity_token

  def execute # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]

    context = {
      current_user: current_resource_owner,
      current_member: @current_member,
      extras: { lookahead: lookaheads(query) }
    }
    result = if valid_query?(query)
               SmartVillageAppMainserverSchema.execute(
                 query,
                 variables: variables,
                 context: context,
                 operation_name: operation_name
               )
             else
               { errors: ["Invalid query: empty () found"] }
             end

    log_graphql_execution_error(result, query)
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?

    handle_error_in_development e
  end

  private

    def lookaheads(query)
      return nil unless valid_query?(query)

      begin
        GraphQL::Query.new(SmartVillageAppMainserverSchema, query).lookahead
      rescue StandardError
        nil
      end
    end

    def valid_query?(query)
      # Einfache Überprüfung, ob die Abfrage keine leeren Klammern enthält
      !query.match(/\(\s*\)/)
    end

    def member_by_token
      member_token = request.env["HTTP_X_AUTHORIZATION"]
      return if member_token.blank?

      @current_member = Member.find_by(municipality_id: MunicipalityService.municipality_id,
                                       authentication_token: member_token)
    end

    def current_resource_owner
      owner_id = doorkeeper_token.try(:application).try(:owner_id) if doorkeeper_token
      User.find_by(id: owner_id) if owner_id.present?
    end

    def log_graphql_execution_error(result, query)
      result_hash = result.to_h
      return unless result_hash.key?("errors")

      error_hash = { GraphQLServerError: result_hash, payload: query }
      logger.error(error_hash)
    end

    # Handle form data, JSON body, or a blank value
    def ensure_hash(ambiguous_param) # rubocop:disable Metrics/MethodLength
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
