# frozen_string_literal: true

GraphiQL::Rails.config.query_params = true
GraphiQL::Rails.config.title = "SmartVillageApp GraphQL Documentation"
GraphiQL::Rails.config.initial_query = "# Load all events
query {
  eventRecords {
    id
    title
    listDate
    dataProvider {
      name
    }
    addresses {
      city
      street
      zip
    }
  }
}"
GraphiQL::Rails.config.headers["Authorization"] = ->(context) { "bearer #{context.cookies["_graphql_token"]}" }
