# frozen_string_literal: true

# Service to create GenericItem with type Announcement from Shout
class CreateShoutService
  def initialize(data_provider: nil, params: {})
    @data_provider = data_provider
    @params = params
  end

  def call
    item = create_generic_item!
    create_related_data!(item)
    item.reload
  rescue StandardError => e
    Rails.logger.error "Error creating item: #{e.message}"
  end

  private

    attr_reader :data_provider, :params

    def create_generic_item!
      item = GenericItem.new(initial_item_params)
      item.data_provider = data_provider
      item.save!
      item
    end

    def create_related_data!(item)
      GenericItem.transaction do
        create_opening_hours(item)
        create_categories(item)
        create_addresses(item)
        create_media_contents(item)
        create_quota(item)
      end
    end

    def create_opening_hours(item)
      return unless opening_hours_params.present?

      item.opening_hours.create(opening_hours_params)
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

      item.create_quota(quota_params)
    end

    def initial_item_params
      {
        title: @params[:title],
        description: @params[:description],
        generic_type: GenericItem::GENERIC_TYPES[:announcement],
        generic_itemable_type: @params[:announcementable_type],
        generic_itemable_id: @params[:announcementable_id],
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
        frequency: @params[:quota_frequency] || "once"
      }
    end
end
