# frozen_string_literal: true

RSpec.shared_examples "an unauthorized request" do
  response "401", "unauthorized" do
    let(:Authorization) { "Bearer invalidtoken" }
    run_test!
  end
end
