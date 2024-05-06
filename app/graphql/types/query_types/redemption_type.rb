# frozen_string_literal: true

module Types
  class QueryTypes::RedemptionType < Types::BaseObject
    field :id, GraphQL::Types::ID, null: true
    field :public_name, String, null: true

    def id
      object.member_id
    end

    def public_name
      # object.member&.public_name
    end
  end
end
