# frozen_string_literal: true

require "rails_helper"

RSpec.describe ContentBlock, type: :model do
  it { is_expected.to belong_to(:content_blockable) }
  it { is_expected.to have_many(:media_contents) }

  ["title", "intro", "body"].each do |column|
    it "should remove emojis from #{column} before saving" do
      content_block =  FactoryBot.build(:content_block, {
        column.to_sym => "test😊😍😌🤕👿👹👧👧🏻👧🏼👧🏽🏼👍🏽👌☝🏼🥝🥦🌶🌽🍎",
        content_blockable: FactoryBot.create(:news_item)
      })

      expect(content_block.save).to be true
      expect(content_block.send(column)).to eq('test')
    end
  end

  it "is able to save when title is nil" do
    content_block =  FactoryBot.build(:content_block,
      title: nil,
      content_blockable: FactoryBot.create(:news_item)
    )
    expect(content_block.save).to be true
  end

  it "is able to save when intro is nil" do
    content_block =  FactoryBot.build(:content_block,
      intro: nil,
      content_blockable: FactoryBot.create(:news_item)
    )
    expect(content_block.save).to be true
  end

  it "is able to save when body is nil" do
    content_block =  FactoryBot.build(:content_block,
      body: nil,
      content_blockable: FactoryBot.create(:news_item)
    )
    expect(content_block.save).to be true
  end
end

# == Schema Information
#
# Table name: content_blocks
#
#  id                     :bigint           not null, primary key
#  title                  :text(65535)
#  intro                  :text(65535)
#  body                   :text(65535)
#  content_blockable_type :string(255)
#  content_blockable_id   :bigint
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
