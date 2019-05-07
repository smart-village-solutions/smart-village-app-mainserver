module Types
  class QueryType < Types::BaseObject
    field :all_pois, [PointOfInterestType], null: false


    def all_pois
      PointOfInterest.all
    end
  end
end
