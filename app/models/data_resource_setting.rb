# frozen_string_literal: true

class DataResourceSetting < ApplicationRecord

  DATA_RESOURCES = [Tour, PointOfInterest, NewsItem, EventRecord].freeze

  store :settings,
        accessors: %i[display_only_summary always_recreate_on_import only_summary_link_text convert_media_urls_to_external_storage],
        coder: JSON

  belongs_to :data_provider
end

# == Schema Information
#
# Table name: data_resource_settings
#
#  id                 :bigint           not null, primary key
#  data_provider_id   :integer
#  data_resource_type :string(255)
#  settings           :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
