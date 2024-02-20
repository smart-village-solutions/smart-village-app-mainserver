# frozen_string_literal: true

module ResponseHelpers
  def parse_json(response)
    JSON.parse(response.body)
  end

  def expect_error_message(response, message)
    json_response = parse_json(response)
    expect(json_response["errors"]).to include(message)
  end

  def expect_attribute_value(response, attribute_path, expected_value)
    json_response = parse_json(response)
    attribute_value = json_response.dig(*attribute_path)
    expect(attribute_value).to eq(expected_value)
  end
end

RSpec.configure do |config|
  config.include ResponseHelpers, type: :request
end
