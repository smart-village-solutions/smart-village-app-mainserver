# frozen_string_literal: true

class StaticContent < ApplicationRecord
  # we need the scope for destroying records, but we do not have any specifics
  # for current users at static contents, so we return `all`
  scope :filtered_for_current_user, lambda { |_current_user|
    all
  }

  attr_accessor :force_create

  validates_presence_of :name, :data_type
  validates :name, uniqueness: { case_sensitive: false }

  scope :filter_by_type, ->(type) { where data_type: type }
end

# == Schema Information
#
# Table name: static_contents
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  data_type  :string(255)
#  content    :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
