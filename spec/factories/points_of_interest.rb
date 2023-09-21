# frozen_string_literal: true

FactoryBot.define do
  factory :point_of_interest do
    external_id { 1 }
    data_provider
    name { "MyString" }
    description { "MyString" }
    mobile_description { "MyString" }
    active { true }
  end
end

# == Schema Information
#
# Table name: attractions
#
#  id                 :bigint           not null, primary key
#  external_id        :integer
#  name               :string(255)
#  description        :string(255)
#  mobile_description :string(255)
#  active             :boolean          default(TRUE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
