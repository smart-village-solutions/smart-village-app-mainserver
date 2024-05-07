# frozen_string_literal: true

module JsonFilterParseable
  extend ActiveSupport::Concern

  def parse_and_validate_filter_json(filter_value)
    filter_json = JSON.parse(filter_value)
    raise GraphQL::ExecutionError, "Invalid filter structure." unless filter_json.is_a?(Hash)

    filter_json
  rescue JSON::ParserError
    raise GraphQL::ExecutionError, "Invalid JSON format for filter."
  end
end
