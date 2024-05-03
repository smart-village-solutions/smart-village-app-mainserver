# frozen_string_literal: true

module Mutations
  class UpdateShout < BaseMutation
    argument :id, ID, required: true, description: "ID of the Shout(GenericItem with type Announcement) to update"
    argument :title, String, required: false
    argument :description, String, required: false
    argument :date_start, String, required: false
    argument :date_end, String, required: false
    argument :time_start, String, required: false
    argument :time_end, String, required: false
    argument :organizer, Types::InputTypes::ShoutOrganizerInput, required: false
    argument :announcement_types, [String], required: false
    argument :max_number_of_quota, Integer, required: false
    argument :quota_frequency, String, required: false
    argument :participants, [ID], required: false
    argument :media_content, Types::InputTypes::MediaContentInput, required: false
    argument :location, Types::InputTypes::AddressInput, required: false
    argument :announcementable_type, String, required: false
    argument :announcementable_id, String, required: false

    type Types::QueryTypes::ShoutType

    def resolve(id:, **args)
      return unless context[:current_user]&.data_provider

      shout = GenericItem.announcements_type.find(id)
      return unless shout

      Shouts::UpdateShoutService.new(
        item: shout,
        data_provider: context[:current_user].data_provider,
        params: args
      ).call
    end
  end
end
