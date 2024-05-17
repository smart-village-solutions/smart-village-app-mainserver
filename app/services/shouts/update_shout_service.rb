# frozen_string_literal: true

module Shouts
  class UpdateShoutService < BaseShoutService
    def initialize(item:, data_provider: nil, params: {})
      super(data_provider: data_provider, params: params)
      @item = item
    end

    def call
      update_generic_item!
      update_related_data!
      update_participants! if @params[:participants]
      item.reload
    rescue StandardError => e
      Rails.logger.error "Error updating shout: #{e.message}"
    end

    private

      attr_accessor :item

      def update_generic_item!
        item.update!(initial_item_params)
      end

      def update_related_data!
        GenericItem.transaction do
          update_opening_hours!
          update_categories!
          update_addresses!
          update_media_contents!
          update_quota!
        end
      end

      def update_opening_hours!
        item.opening_hours.first.update(opening_hours_params) if opening_hours_params.present?
      end

      def update_categories!
        return unless categories_params.present?

        current_categories = item.categories.pluck(:name)
        new_categories = categories_params - current_categories
        old_categories = current_categories - categories_params

        # Add new categories
        new_categories.each do |category_name|
          category = Category.find_or_create_by(name: category_name)
          item.categories << category
        end

        # Remove old categories
        old_categories.each do |category_name|
          category = Category.find_by(name: category_name)
          item.categories.delete(category) if category
        end
      end

      def update_addresses!
        return unless location_params.present?

        item.addresses.first.update(location_params)
      end

      def update_media_contents!
        return unless media_content_params.present?

        item.media_contents.first.update(media_content_params)
      end

      def update_quota!
        return unless @params.key?(:max_number_of_quota)

        if item.quota
          item.quota.update(quota_params)
        else
          item.create_quota(quota_params)
        end
      end

      def update_participants!
        return unless @params[:participants].present?

        Shouts::ManageShoutParticipantsService.new(item, @params[:participants]).call
      end
  end
end
