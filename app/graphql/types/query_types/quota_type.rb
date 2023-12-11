module Types
  class QueryTypes::QuotaType < Types::BaseObject
    field :id, GraphQL::Types::ID, null: true
    field :max_quantity, Integer, null: true
    field :frequency, String, null: true
    field :max_per_person, Integer, null: true
  end
end
