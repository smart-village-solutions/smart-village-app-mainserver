# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # creations
    field :create_news_item, mutation: Mutations::CreateNewsItem
    field :create_tour, mutation: Mutations::CreateTour
    field :create_event_record, mutation: Mutations::CreateEventRecord
    field :create_point_of_interest, mutation: Mutations::CreatePointOfInterest
    field :create_app_user_content, mutation: Mutations::CreateAppUserContent

    # destroys
    field :destroy_record, mutation: Mutations::DestroyRecord
  end
end
