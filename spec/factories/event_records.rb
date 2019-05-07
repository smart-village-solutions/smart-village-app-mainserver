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
#  id             :bigint           not null, primary key
#  parent_id      :integer
#  region         :string(255)
#  description    :string(255)
#  repeat         :boolean
#  title          :string(255)
#  category_id    :bigint
#  updated_at_tmb :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
