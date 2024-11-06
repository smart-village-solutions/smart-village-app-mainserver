# frozen_string_literal: true

# News Item is one of the four Main resources for the app. A news Item can be anything
# from an old school news article to a whole story structured in chapters
class NewsItem < ApplicationRecord
  include FilterByRole

  attr_accessor :force_create
  attr_accessor :category_name
  attr_accessor :category_names
  attr_accessor :push_notification

  before_save :remove_emojis
  after_save :find_or_create_category
  after_save :send_push_notification

  belongs_to :data_provider

  has_one :address, as: :addressable, dependent: :destroy
  has_one :external_reference, as: :external, dependent: :destroy
  has_one :source_url, as: :web_urlable, class_name: "WebUrl", dependent: :destroy
  has_many :data_resource_categories, -> { where(data_resource_type: "NewsItem") }, foreign_key: :data_resource_id
  has_many :categories, through: :data_resource_categories
  has_many :content_blocks, as: :content_blockable, dependent: :destroy

  store :payload, coder: JSON

  scope :by_category, lambda { |category_id|
    where(categories: { id: category_id }).joins(:categories)
  }

  # defined by FilterByRole
  # scope :visible, -> { where(visible: true) }

  accepts_nested_attributes_for :content_blocks, :data_provider, :address, :source_url

  def unique_id
    return external_id if external_id.present?

    title = content_blocks.first.try(:title)
    fields = [title, published_at]

    generate_checksum(fields)
  end

  def settings
    data_provider.data_resource_settings.where(data_resource_type: "NewsItem").first.try(:settings)
  end

  # Sicherstellung der Abwärtskompatibilität seit 09/2020
  def category
    ActiveSupport::Deprecation.warn(":category is replaced by has_many :categories")
    categories.first
  end

  def content_for_facebook
    content_block = content_blocks.first
    message = [
      content_block.try(:title),
      content_block.try(:intro),
      content_block.try(:body)
    ].compact.delete_if(&:blank?).join("\n\n")

    {
      message: message,
      link: source_url.try(:url).presence || ""
    }
  end

  private

    def find_or_create_category
      # für Abwärtskompatibilität, wenn nur ein einiger Kategorienamen angegeben wird
      # ist der attr_accessor :category_name befüllt
      if category_name.present?
        category_to_add = Category.where(name: category_name).first_or_create
        categories << category_to_add unless categories.include?(category_to_add)
      end

      # Wenn mehrere Kategorien auf einmal gesetzt werden
      # ist der attr_accessor :category_names befüllt
      if category_names.present?
        category_names.each do |category|
          next unless category[:name].present?
          category_to_add = Category.where(name: category[:name]).first_or_create
          categories << category_to_add unless categories.include?(category_to_add)
        end
      end
    end

    def send_push_notification
      # do not send push notifications, if not explicitly requested
      return unless push_notification.to_s == "true"
      # do not send push notification, if already sent
      return if push_notifications_sent_at.present?

      push_title = title.presence || content_blocks.try(:first).try(:title).presence || "Neue Nachricht"
      push_body = content_blocks.try(:first).try(:intro).presence || push_title
      push_body = ActionView::Base.full_sanitizer.sanitize(push_body)
      if payload.present?
        payload_with_underscore_keys = payload.transform_keys { |key| key.to_s.underscore }
        mowas_regional_keys = payload_with_underscore_keys.fetch(:regional_keys, [])
        mowas_regional_keys = mowas_regional_keys.map { |key| key.to_i }
      end

      options = {
        title: push_title,
        body: push_body,
        data: {
          id: id,
          query_type: self.class.to_s,
          data_provider_id: data_provider.id,
          mowas_regional_keys: mowas_regional_keys
        }
      }

      PushNotification.delay.send_notifications(options)

      touch(:push_notifications_sent_at)
    end

    def remove_emojis
      self.title = RemoveEmoji::Sanitize.call(title) if title.present?
    end
end

# == Schema Information
#
# Table name: news_items
#
#  id                         :bigint           not null, primary key
#  author                     :string(255)
#  full_version               :boolean
#  characters_to_be_shown     :integer
#  publication_date           :datetime
#  published_at               :datetime
#  show_publish_date          :boolean
#  news_type                  :string(255)
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  data_provider_id           :integer
#  external_id                :text(65535)
#  title                      :string(255)
#  visible                    :boolean          default(TRUE)
#  push_notifications_sent_at :datetime
#  payload                    :text(65535)
#
