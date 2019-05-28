# frozen_string_literal: true

class GraphqlController < ApplicationController
  # To activate access control by doorkeeper, uncomment next line
  # before_action :doorkeeper_authorize!

  protect_from_forgery with: :null_session

  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      # Query context goes here, for example:
      # current_user: current_user,
    }
    result = SmartVillageAppMainserverSchema.execute(
      query,
      variables: variables,
      context: context,
      operation_name: operation_name
    )
    render json: result
  rescue StandardError => error
    raise error unless Rails.env.development?

    handle_error_in_development error
  end

  private

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
