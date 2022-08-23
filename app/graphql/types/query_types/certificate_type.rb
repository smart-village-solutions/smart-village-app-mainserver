# frozen_string_literal: true

module Types
  class QueryTypes::CertificateType < Types::BaseObject
    field :id, GraphQL::Types::ID, null: true
    field :name, String, null: true
  end
end
