# frozen_string_literal: false

module Mutations
  class DestroyNewsItem < BaseMutation
    argument :id, Integer, required: true

    type Types::NewsItemType

    def resolve(id:)
      NewsItem.find(id).destroy
    end
  end
end