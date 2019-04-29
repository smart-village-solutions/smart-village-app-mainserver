class MediaContent < ApplicationRecord
  belongs_to :mediaable, polymorphic: true
  has_one :web_url, as: :web_urlable
end

# == Schema Information
#
# Table name: media_contents
#
#  id            :bigint(8)        not null, primary key
#  caption_text  :string(255)
#  copyright     :string(255)
#  height        :string(255)
#  width         :string(255)
#  type          :string(255)
#  mediaable_type :string(255)
#  mediaable_id   :bigint(8)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
