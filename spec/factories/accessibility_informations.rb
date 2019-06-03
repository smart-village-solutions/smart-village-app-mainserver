# frozen_string_literal: true

FactoryBot.define do
  factory :accessibility_information do
    description { "MyString" }
    types { "MyString" }
    web_url { nil }
  end
end

# == Schema Information
#
# Table name: accessibility_informations
#
#  id              :bigint           not null, primary key
#  description     :text(65535)
#  types           :string(255)
#  accessable_type :string(255)
#  accessable_id   :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
