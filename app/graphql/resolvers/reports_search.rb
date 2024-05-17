# frozen_string_literal: true

require "search_object/plugin/graphql"

class Resolvers::ReportsSearch < GraphQL::Schema::Resolver
  include SearchObject.module(:graphql)

  type types[Types::QueryTypes::ReportType]

  scope do
    if context[:current_user]&.admin_role?
      Report.all.order(created_at: :desc)
    else
      Report.none
    end
  end
end
