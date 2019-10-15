# frozen_string_literal: true

# News Item is one of the four Main resources for the app. A news Item can be anything
# from an old school news article to a whole story structured in chapters
class NewsItem < ApplicationRecord
  attr_accessor :force_create

  belongs_to :data_provider

  has_many :content_blocks, as: :content_blockable, dependent: :destroy
  has_one :external_reference, as: :external, dependent: :destroy
  has_one :address, as: :addressable, dependent: :destroy
  has_one :source_url, as: :web_urlable, class_name: "WebUrl", dependent: :destroy

  scope :filtered_for_current_user, ->(current_user) do
    return all if current_user.admin_role?

    where(data_provider_id: current_user.data_provider_id)
  end

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
end

# == Schema Information
#
# Table name: news_items
#
#  id                     :bigint           not null, primary key
#  author                 :string(255)
#  full_version           :boolean
#  characters_to_be_shown :integer
#  publication_date       :datetime
#  published_at           :datetime
#  show_publish_date      :boolean
#  news_type              :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  data_provider_id       :integer
#  external_id            :bigint
#  title                  :string(255)
#
