# frozen_string_literal: true

require "rails_helper"

RSpec.describe NewsItem, type: :model do
  it { is_expected.to have_many(:content_blocks) }
  it { is_expected.to have_one(:address) }
  it { is_expected.to have_one(:data_provider) }
end

# == Schema Information
#
# Table name: news_items
#
#  id                         :bigint           not null, primary key
#  author                     :string(255)
#  full_version               :boolean
#  characters_to_be_shown     :integer
#  publication_date           :datetime
#  published_at               :datetime
#  show_publish_date          :boolean
#  news_type                  :string(255)
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  data_provider_id           :integer
#  external_id                :text(65535)
#  title                      :string(255)
#  visible                    :boolean          default(TRUE)
#  push_notifications_sent_at :datetime
#  payload                    :text(65535)
#
