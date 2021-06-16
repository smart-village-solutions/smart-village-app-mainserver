# frozen_string_literal: true

require "search_object/plugin/graphql"
require "graphql/query_resolver"

class Resolvers::SurveysSearch
  include SearchObject.module(:graphql)

  # NOTE: following line is needed by the SearchObject module but cannot be used in `fetch_results`
  scope { Survey::Poll.filtered_for_current_user(context[:current_user]) }

  type types[Types::QueryTypes::SurveyPollType]

  option :ids, type: types[types.ID]

  # https://github.com/nettofarah/graphql-query-resolver

  def fetch_results
    # NOTE: scope from class is not available here, so we need to create a local scope here :/
    scope = Survey::Poll.filtered_for_current_user(context[:current_user])

    # select only available ids
    scope = scope.where(id: ids) if ids.present? && ids.any?

    {
      all: scope.all,
      active: scope.active,
      archived: scope.archived
    }
  end
end
