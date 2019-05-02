# frozen_string_literal: true

require "rails_helper"

RSpec.describe ContentBlock, type: :model do
  it { is_expected.to belong_to(:content_blockable) }
  it { is_expected.to have_many(:media_contents) }
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
