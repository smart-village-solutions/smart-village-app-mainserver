# frozen_string_literal: true
require 'rails_helper'

describe JsonFilterParseable do
  include_context "with graphql"

  class DummyResolver < GraphQL::Schema::Resolver
    include JsonFilterParseable
    def resolve(filter_value)
      parse_and_validate_filter_json(filter_value)
    end
  end

  subject { DummyResolver.new(object: nil, context: {}, field: nil) }

  describe "#parse_and_validate_json" do
    it "is not raise an error when filter is blank" do
      expect(subject.resolve("{}")).to eq({})
    end

    it "raises an error when JSON is malformed" do
      expect { subject.resolve("not_a_json") }.to raise_error(GraphQL::ExecutionError, "Invalid JSON format for filter.")
    end

    it "raises an error when the JSON is not a hash" do
      expect { subject.resolve("[]") }.to raise_error(GraphQL::ExecutionError, "Invalid filter structure.")
    end
  end
end
