# frozen_string_literal: true

# This model provides media content of various types to any other resource who
# needs one or more media contents.
class MediaContent < ApplicationRecord
  belongs_to :mediaable, polymorphic: true
  has_one :source_url, as: :web_urlable, class_name: "WebUrl", dependent: :destroy
  validates_presence_of :content_type

  accepts_nested_attributes_for :source_url, reject_if: ->(attr) { attr[:url].blank? }
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
