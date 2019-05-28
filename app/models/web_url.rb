# frozen_string_literal: true

class WebUrl < ApplicationRecord
  belongs_to :web_urlable, polymorphic: true
  # Test mit Logo URL von TMB schlägt hier fehl:
  # http://resources.mynewsdesk.com/image/upload/t_next_gen_logo_limit_x2_png/fqjeebritc4zo6v118j9.png
  # validates :url, format: { with: %r{\A(http|https)://[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(/.*)?\z}ix }
  validates_presence_of :url
end

# == Schema Information
#
# Table name: web_urls
#
#  id               :bigint           not null, primary key
#  url              :string(255)
#  description      :string(255)
#  web_urlable_type :string(255)
#  web_urlable_id   :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
