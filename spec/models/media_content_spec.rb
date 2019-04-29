require 'rails_helper'

RSpec.describe MediaContent, type: :model do
  it { should belong_to(:mediable) }
  it { should have_one(:web_url) }
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
#  mediable_type :string(255)
#  mediable_id   :bigint(8)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
