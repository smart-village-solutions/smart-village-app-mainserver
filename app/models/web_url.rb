# frozen_string_literal: true

class WebUrl < ApplicationRecord
  belongs_to :web_urlable, polymorphic: true
  validates_presence_of :url
end

# == Schema Information
#
# Table name: web_urls
#
#  id               :bigint           not null, primary key
#  url              :text(65535)
#  description      :text(65535)
#  web_urlable_type :string(255)
#  web_urlable_id   :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
