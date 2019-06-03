# frozen_string_literal: true

FactoryBot.define do
  factory :event_record do
    region { "MyString" }
    description { "MyString" }
    repeat { false }
    title { "MyString" }
  end
end

# == Schema Information
#
# Table name: event_records
#
#  id          :bigint           not null, primary key
#  parent_id   :integer
#  region_id   :bigint
#  description :text(65535)
#  repeat      :boolean
#  title       :string(255)
#  category_id :bigint
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
