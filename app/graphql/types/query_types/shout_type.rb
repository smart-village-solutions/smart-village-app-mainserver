# frozen_string_literal: true

module Types
  class QueryTypes::ShoutType < Types::BaseObject
    field :id, GraphQL::Types::ID, null: true
    field :title, String, null: true
    field :description, String, null: true
    field :generic_type, String, null: true

    field :date_start, String, null: true
    field :date_end, String, null: true
    field :time_start, String, null: true
    field :time_end, String, null: true

    field :announcement_types, [String], null: true
    field :media_content, Types::QueryTypes::MediaContentType, null: true

    field :location, Types::QueryTypes::AddressType, null: true

    field :max_number_of_quota, Integer, null: true
    field :quota_frequency, String, null: true
    field :quota_visibility, String, null: true

    field :participants, [ID], null: true

    field :organizer, Types::QueryTypes::ShoutOrganizerType, null: true

    field :announcementable_type, String, null: true
    field :announcementable_id, String, null: true

    field :redemptions_count, Integer, null: true
    field :redemptions_list, [Types::QueryTypes::RedemptionType], null: true

    def organizer
      return unless object.data_provider

      {
        organizer_type: "data_provider",
        organizer_id: object.data_provider.id
      }
    end

    def date_start
      return unless opening_hours_item&.date_from

      prepared_date_time(opening_hours_item&.date_from)
    end

    def date_end
      return unless opening_hours_item&.date_to

      prepared_date_time(opening_hours_item&.date_to)
    end

    def time_start
      return unless opening_hours_item&.time_from

      prepared_date_time(opening_hours_item&.time_from, is_date: false)
    end

    def time_end
      return unless opening_hours_item&.time_to

      prepared_date_time(opening_hours_item&.time_to, is_date: false)
    end

    def media_content
      object.media_contents.first
    end

    def announcement_types
      object.categories.map(&:name)
    end

    def max_number_of_quota
      object.quota&.max_quantity
    end

    def quota_frequency
      object.quota&.frequency
    end

    def location
      object.addresses.first
    end

    def participants
      object.quota&.redemptions&.map(&:member_id)
    end

    def announcementable_type
      object.generic_itemable_type
    end

    def announcementable_id
      object.generic_itemable_id
    end

    def redemptions_count
      object.quota&.redemptions&.uniq&.count
    end

    def redemptions_list
      object.quota&.redemptions
    end

    def quota_visibility
      object.quota&.visibility
    end

    private

      def opening_hours_item
        @opening_hours_item ||= object.opening_hours.first
      end

      def prepared_date_time(value, is_date: true)
        return unless value

        value.strftime(is_date ? "%Y-%m-%d" : "%H:%M")
      end
  end
end
