# frozen_string_literal: true

require "search_object/plugin/graphql"
require "graphql/query_resolver"

class Resolvers::SurveyPollsSearch
  include SearchObject.module(:graphql)

  scope { Survey::Poll.filtered_for_current_user(context[:current_user]) }

  type types[Types::QueryTypes::SurveyPollType]

  option :ids, type: types[types.ID], with: :apply_ids
  option :ongoing, type: types.Boolean, with: :apply_ongoing
  option :archived, type: types.Boolean, with: :apply_archived

  def apply_ids(scope, value)
    scope.where(id: value)
  end

  def apply_ongoing(scope, _value)
    scope.ongoing
  end

  def apply_archived(scope, _value)
    scope.archived
  end

  # https://github.com/nettofarah/graphql-query-resolver

  def fetch_results
    # NOTE: Don't run QueryResolver during tests
    return super unless context.present?

    GraphQL::QueryResolver.run(Survey::Poll, context, Types::QueryTypes::SurveyPollType) do
      super
    end
  end
end
