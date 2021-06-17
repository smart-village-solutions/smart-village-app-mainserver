# frozen_string_literal: true

FactoryBot.define do
  factory :data_resource_setting do
    data_provider_id { 1 }
    data_resource_type { "MyString" }
    data_resource_id { 1 }
    settings { "MyString" }
  end
end

# == Schema Information
#
# Table name: data_resource_settings
#
#  id                 :bigint           not null, primary key
#  data_provider_id   :integer
#  data_resource_type :string(255)
#  settings           :text(16777215)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
