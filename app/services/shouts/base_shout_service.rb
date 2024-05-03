# frozen_string_literal: true

module Shouts
  class BaseShoutService
    def initialize(data_provider: nil, params: {})
      @data_provider = data_provider
      @params = params
    end

    def call
      raise NotImplementedError
    end

    protected

      attr_reader :data_provider, :params

      def initial_item_params
        data = {
          title: @params[:title],
          description: @params[:description],
          generic_type: GenericItem::GENERIC_TYPES[:announcement]
        }

        data.merge!(generic_itemable_params) if @params[:announcementable_type].present? && @params[:announcementable_id].present?
        data
      end

      def generic_itemable_params
        {
          generic_itemable_type: @params[:announcementable_type],
          generic_itemable_id: @params[:announcementable_id]
        }
      end

      def organizer_params
        @params[:organizer].to_h
      end

      def opening_hours_params
        {
          date_from: @params[:date_start],
          date_to: @params[:date_end],
          time_from: @params[:time_start],
          time_to: @params[:time_end]
        }
      end

      def categories_params
        @params[:announcement_types]
      end

      def location_params
        @params[:location].to_h
      end

      def media_content_params
        @params[:media_content].to_h
      end

      def quota_params
        {
          max_quantity: @params[:max_number_of_quota],
          frequency: @params[:quota_frequency] || 0 # default to 0 ('once') if not provided in params
        }
      end
  end
end
