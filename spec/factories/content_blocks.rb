# frozen_string_literal: true

FactoryBot.define do
  factory :content_block do
    title { "MyString" }
    intro { "MyString" }
    body { "MyText" }
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
