# frozen_string_literal: true

#rubocop:disable all
class Announcements::CreateService
  def initialize(params)
    @params = params
  end

  def call
    GenericItem.transaction do
      item = GenericItem.new(initial_item_params)
      item.member_id = member.id if member
      item.data_provider_id = data_provider.id if data_provider

      if item.save
        create_opening_hours(item)
        create_categories(item)
        create_addresses(item)
        create_media_contents(item)
        create_quota(item)
        item
      else
        raise ActiveRecord::Rollback, "Failed to save GenericItem: #{item.errors.full_messages.join(', ')}"
      end
    end
  end

  private

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

  def member
    return nil unless organizer_params[:organizer_type] == "member"

    Member.find_by(id: organizer_params[:organizer_id])
  end

  def data_provider
    return nil unless organizer_params[:organizer_type] == "data_provider"

    DataProvider.find_by(id: organizer_params[:organizer_id])
  end

  def create_opening_hours(item)
    return unless opening_hours_params.present?

    item.opening_hours.build(opening_hours_params)
  end

  def create_categories(item)
    return if categories_params.blank?

    categories_params.compact.reject(&:empty?).each do |category_name|
      category = Category.find_or_create_by(name: category_name)
      item.categories << category
    end
  end

  def create_addresses(item)
    return unless location_params.present?

    item.addresses.build(location_params)
  end

  def create_media_contents(item)
    return unless media_content_params.present?

    item.media_contents.build(media_content_params)
  end

  def create_quota(item)
    return unless @params[:max_number_of_quota].present?

    item.build_quota(max_number_of_quota: @params[:max_number_of_quota])
  end
end
