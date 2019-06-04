# frozen_string_literal: true

# News Item is one of the four Main resources for the app. A news Item can be anything
# from an old school news article to a whole story structured in chapters
class NewsItem < ApplicationRecord
  belongs_to :data_provider

  has_many :content_blocks, as: :content_blockable
  has_one :address, as: :addressable
  has_one :source_url, as: :web_urlable, class_name: "WebUrl"

  accepts_nested_attributes_for :content_blocks, :data_provider, :address, :source_url
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
#
