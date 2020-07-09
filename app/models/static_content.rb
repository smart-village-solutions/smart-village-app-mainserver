# frozen_string_literal: true

class StaticContent < ApplicationRecord
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
