# frozen_string_literal: true

# This model provides media content of various types to any other resource who
# needs one or more media contents.
class MediaContent < ApplicationRecord
  belongs_to :mediaable, polymorphic: true, optional: true
  has_one :source_url, as: :web_urlable, class_name: "WebUrl", dependent: :destroy
  has_one_attached :attachment

  after_create :convert_source_url_to_external_storage

  validates_presence_of :content_type

  accepts_nested_attributes_for :source_url, reject_if: ->(attr) { attr[:url].blank? }

  # if in configs for a resource defined, move an asset to defined external storage
  # and switch urls stored in source_url.
  def convert_source_url_to_external_storage
    return unless converting_activated_for_current_resource?

    endpoint = Rails.application.credentials.dig(:minio, :endpoint)
    return if endpoint.blank?
    return if source_url.blank? || source_url.url.blank?
    return if source_url.url.start_with?(endpoint)

    begin
      uri = URI.open(source_url.url)
      file = File.open(uri)
      attachment.attach(
        io: file,
        filename: File.basename(URI.parse(source_url.url).path) || File.basename(file),
        content_type: uri.content_type
      )
    rescue StandardError
      return
    end

    source_url.url = attachment.service_url.sub(/\?.*/, "")
    source_url.save
  end

  # Sollen die Medien für die aktuelle Resource und den aktuellen DataProvider
  # selbst gehostet werden?
  def converting_activated_for_current_resource?
    mediaable_class_name = mediaable.class.to_s
    return false if mediaable_class_name.blank?
    return false if mediaable.try(:data_provider).blank?

    resource_configs = mediaable.data_provider.data_resource_settings.where(
      data_resource_type: mediaable_class_name
    ).first
    return false if resource_configs.blank? || resource_configs.settings.blank?

    resource_configs.settings.fetch("convert_media_urls_to_external_storage", "false") == "true"
  end
end

# == Schema Information
#
# Table name: media_contents
#
#  id             :bigint           not null, primary key
#  caption_text   :text(65535)
#  copyright      :string(255)
#  height         :string(255)
#  width          :string(255)
#  content_type   :string(255)
#  mediaable_type :string(255)
#  mediaable_id   :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
