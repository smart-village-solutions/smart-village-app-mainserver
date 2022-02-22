# frozen_string_literal: true

# This model provides an contact object to every other resource which needs one.
class ContentBlock < ApplicationRecord
  has_many :media_contents, as: :mediaable, dependent: :destroy
  belongs_to :content_blockable, polymorphic: true

  accepts_nested_attributes_for :media_contents

  before_save :remove_emojis

  private

    def remove_emojis
      self.title = RemoveEmoji::Sanitize.call(title) if title.present?
      self.intro = RemoveEmoji::Sanitize.call(intro) if intro.present?
      self.body = RemoveEmoji::Sanitize.call(body) if body.present?
    end
end

# == Schema Information
#
# Table name: content_blocks
#
#  id                     :bigint           not null, primary key
#  title                  :text(65535)
#  intro                  :text(65535)
#  body                   :text(65535)
#  content_blockable_type :string(255)
#  content_blockable_id   :bigint
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
