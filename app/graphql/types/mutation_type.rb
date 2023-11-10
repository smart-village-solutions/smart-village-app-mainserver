# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # creations
    field :create_news_item, mutation: Mutations::CreateNewsItem
    field :create_generic_item, mutation: Mutations::CreateGenericItem
    field :create_tour, mutation: Mutations::CreateTour
    field :create_event_record, mutation: Mutations::CreateEventRecord
    field :create_point_of_interest, mutation: Mutations::CreatePointOfInterest
    field :create_app_user_content, mutation: Mutations::CreateAppUserContent
    field :create_waste_location, mutation: Mutations::CreateWasteLocation
    field :assign_waste_location_to_tour, mutation: Mutations::AssignWasteLocationToTour
    field :create_waste_tour, mutation: Mutations::CreateWasteTour
    field :create_waste_pick_up_time, mutation: Mutations::CreateWastePickUpTime
    field :update_waste_tour_dates, mutation: Mutations::UpdateWasteTourDates
    field :create_or_update_survey_poll, mutation: Mutations::CreateOrUpdateSurveyPoll
    field :create_or_update_static_content, mutation: Mutations::CreateOrUpdateStaticContent
    field :send_push_notification, mutation: Mutations::SendPushNotification
    field :schedule_push_notification, mutation: Mutations::SchedulePushNotification
    field :create_generic_item_message, mutation: Mutations::CreateGenericItemMessage
    field :import_gtfs_feeds, mutation: Mutations::ImportGtfsFeeds

    # destroys
    field :destroy_record, mutation: Mutations::DestroyRecord

    # actions
    field :change_visibility, mutation: Mutations::ChangeVisibility
    field :vote_for_survey,
          mutation: Mutations::VoteForSurvey,
          deprecation_reason: "Use `votesForSurvey` instead."
    field :votes_for_survey, mutation: Mutations::VotesForSurvey
    field :comment_survey, mutation: Mutations::CommentSurvey
  end
end
