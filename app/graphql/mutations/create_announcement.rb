# frozen_string_literal: true

module Mutations
  class CreateAnnouncement < BaseMutation
    argument :title, String, required: false
    argument :description, String, required: false
    argument :date_start, String, required: false
    argument :date_end, String, required: false
    argument :time_start, String, required: false
    argument :time_end, String, required: false
    argument :organizer, Types::InputTypes::AnnouncementOrganizerInput, required: true
    argument :announcement_types, [String], required: false
    argument :max_number_of_quota, Integer, required: false
    argument :participants, [ID], required: false
    argument :media_content, Types::InputTypes::MediaContentInput, required: false
    argument :location, Types::InputTypes::AddressInput, required: false
    argument :announcementable_type, String,
             required: true,
             description: "Type of the associated entity ('NewsItem', 'EventRecord', 'Attraction')"
    argument :announcementable_id, String, required: true, description: "ID of the associated entity"
    argument :is_participants_list_public, Boolean, required: false

    type Types::QueryTypes::GenericItemType

    def resolve(**args)
      Announcements::CreateService.new(args).call
    end
  end
end
