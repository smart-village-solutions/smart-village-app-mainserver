# frozen_string_literal: true

class DataResourceSetting < ApplicationRecord
  DATA_RESOURCES = [Tour, PointOfInterest, NewsItem, EventRecord, GenericItem].freeze

  store :settings,
        accessors: %i[
          display_only_summary
          always_recreate_on_import
          only_summary_link_text
          convert_media_urls_to_external_storage
          default_category_ids
          cleanup_old_records
          post_to_facebook
          facebook_page_id
          facebook_page_access_token
        ],
        coder: JSON

  belongs_to :data_provider

  def has_default_categories?
    return false unless default_category_ids.present?

    default_category_ids.compact.uniq.delete_if(&:blank?).present?
  end
end

# == Schema Information
#
# Table name: data_resource_settings
#
#  id                 :bigint           not null, primary key
#  data_provider_id   :integer
#  data_resource_type :string(255)
#  settings           :text(16777215)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
