# frozen_string_literal: true

# Service to create GenericItem with type Announcement from Shout
module Shouts
  class CreateShoutService < BaseShoutService
    def call
      item = create_generic_item!
      create_related_data!(item)
      add_participants!(item)
      item.reload
    rescue StandardError => e
      Rails.logger.error "Error creating item: #{e.message}"
    end

    private

      def create_generic_item!
        item = GenericItem.new(initial_item_params)
        item.data_provider = data_provider
        item.save!
        item
      end

      def create_related_data!(item)
        GenericItem.transaction do
          create_fixed_dates(item)
          create_categories(item)
          create_addresses(item)
          create_media_contents(item)
          create_quota(item)
        end
      end

      def create_fixed_dates(item)
        return unless fixed_dates_params.present?

        item.dates.create(fixed_dates_params)
      end

      def create_categories(item)
        return if categories_params.blank?

        categories_params.compact.reject(&:empty?).each do |category_name|
          category = Category.find_or_create_by(name: category_name)
          item.categories << category
        end

        item.save
      end

      def create_addresses(item)
        return unless location_params.present?

        item.addresses.create(location_params)
      end

      def create_media_contents(item)
        return unless media_content_params.present?

        item.media_contents.create(media_content_params)
      end

      def create_quota(item)
        return unless @params[:max_number_of_quota].present?

        # default to 'private' if not provided in params
        extended_params = quota_params.merge(
          visibility: @params[:quota_visibility] || Quota.visibilities[:private_visibility]
        )

        item.create_quota(extended_params)
      end

      def add_participants!(item)
        return unless @params[:participants].present?

        Shouts::ManageShoutParticipantsService.new(item, @params[:participants]).call
      end
  end
end
