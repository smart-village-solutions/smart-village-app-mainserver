# frozen_string_literal: true

module Types
  class QueryTypes::CategoryType < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: true
    field :parent, QueryTypes::CategoryType, null: true
    field :children, [QueryTypes::CategoryType], null: true

    field :event_records_count,
          Integer,
          null: true,
          resolve: lambda { |category, _args, ctx|
            location = ctx.irep_node.parent.arguments.location

            event_records = if location
                              category.event_records.by_location(location)
                            else
                              category.event_records
                            end

            event_records.visible.count
          }
    field :event_records,
          [QueryTypes::EventRecordType],
          null: true,
          resolve: lambda { |category, _args, ctx|
            location = ctx.irep_node.parent.arguments.location

            if location
              category.event_records.by_location(location)
            else
              category.event_records
            end
          }
    field :generic_items_count,
          Integer,
          null: true,
          resolve: lambda { |category, _args, ctx|
            location = ctx.irep_node.parent.arguments.location

            generic_items = if location
                              category.generic_items.by_location(location)
                            else
                              category.generic_items
                            end

            generic_items.visible.count
          }
    field :generic_items,
          [QueryTypes::GenericItemType],
          null: true,
          resolve: lambda { |category, _args, ctx|
            location = ctx.irep_node.parent.arguments.location

            if location
              category.generic_items.by_location(location)
            else
              category.generic_items
            end
          }

    field :news_items_count, Integer, null: true
    field :news_items, [QueryTypes::NewsItemType], null: true

    field :points_of_interest_count,
          Integer,
          null: true,
          resolve: lambda { |category, _args, ctx|
            location = ctx.irep_node.parent.arguments.location

            points_of_interest = if location
                                   category.points_of_interest.by_location(location)
                                 else
                                   category.points_of_interest
                                 end

            points_of_interest.visible.count
          }
    field :points_of_interest,
          [QueryTypes::PointOfInterestType],
          null: true,
          resolve: lambda { |category, _args, ctx|
            location = ctx.irep_node.parent.arguments.location

            if location
              category.points_of_interest.by_location(location)
            else
              category.points_of_interest
            end
          }

    field :tours_count,
          Integer,
          null: true,
          resolve: lambda { |category, _args, ctx|
            location = ctx.irep_node.parent.arguments.location

            tours = if location
                      category.tours.by_location(location)
                    else
                      category.tours
                    end

            tours.visible.count
          }
    field :tours,
          [QueryTypes::TourType],
          null: true,
          resolve: lambda { |category, _args, ctx|
            location = ctx.irep_node.parent.arguments.location

            if location
              category.tours.by_location(location)
            else
              category.tours
            end
          }

    field :upcoming_event_records_count,
          Integer,
          null: true,
          resolve: lambda { |category, _args, ctx|
            location = ctx.irep_node.parent.arguments.location

            upcoming_event_records = if location
                                       category.upcoming_event_records.by_location(location)
                                     else
                                       category.upcoming_event_records
                                     end

            upcoming_event_records.visible.count
          }
    field :upcoming_event_records,
          [QueryTypes::EventRecordType],
          null: true,
          resolve: lambda { |category, _args, ctx|
            location = ctx.irep_node.parent.arguments.location

            if location
              category.upcoming_event_records.by_location(location)
            else
              category.upcoming_event_records
            end
          }
  end
end
