# frozen_string_literal: true

module Mutations
  class CreateShout < BaseMutation
    argument :title, String, required: false
    argument :description, String, required: false
    argument :date_start, String, required: false
    argument :date_end, String, required: false
    argument :time_start, String, required: false
    argument :time_end, String, required: false
    argument :organizer, Types::InputTypes::ShoutOrganizerInput, required: false
    argument :announcement_types, [String], required: false

    argument :max_number_of_quota, Integer, required: false
    argument :participants, [ID], required: false

    argument :media_content, Types::InputTypes::MediaContentInput, required: false
    argument :location, Types::InputTypes::AddressInput, required: false

    argument :announcementable_type, String,
             required: true,
             description: "Type of the associated entity ('NewsItem', 'EventRecord', 'Attraction')"
    argument :announcementable_id, String, required: true, description: "ID of the associated entity"

    type Types::QueryTypes::ShoutType

    def resolve(**args)
      return unless context[:current_user]&.data_provider

      CreateShoutService.new(
        data_provider: context[:current_user].data_provider,
        params: args
      ).call
    end
  end
end
