# frozen_string_literal: true

shared_context "with graphql" do
  let(:context) { {} }
  let(:variables) { {} }
  let(:result) do
    SmartVillageAppMainserverSchema.execute(
      query_string,
      context: context,
      variables: variables
    )
  end
  let(:data) { result["data"] }
  let(:errors) { result["errors"] }
end
