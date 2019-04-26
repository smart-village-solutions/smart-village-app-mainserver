# == Schema Information
#
# Table name: web_urls
#
#  id               :bigint(8)        not null, primary key
#  url              :string(255)
#  description      :string(255)
#  web_urlable_type :string(255)
#  web_urlable_id   :bigint(8)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class WebUrl < ApplicationRecord
    belongs_to :web_urlable, polymorphic: true
end
