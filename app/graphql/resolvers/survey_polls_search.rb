# frozen_string_literal: true

require "search_object/plugin/graphql"

class Resolvers::SurveyPollsSearch < GraphQL::Schema::Resolver
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
end
