# frozen_string_literal: true

FactoryBot.define do
  factory :open_weather_map do
    data { "MyText" }
  end
end

# == Schema Information
#
# Table name: open_weather_maps
#
#  id         :bigint           not null, primary key
#  data       :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
