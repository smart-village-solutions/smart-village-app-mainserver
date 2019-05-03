# frozen_string_literal: true

# This model provides an contact object to every other resource which needs one.
class ContentBlock < ApplicationRecord
  has_many :media_contents, as: :mediaable
  belongs_to :content_blockable, polymorphic: true
end

# == Schema Information
#
# Table name: content_blocks
#
#  id                     :bigint           not null, primary key
#  title                  :string(255)
#  intro                  :string(255)
#  body                   :text(65535)
#  content_blockable_type :string(255)
#  content_blockable_id   :bigint
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
