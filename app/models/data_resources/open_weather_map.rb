# frozen_string_literal: true

class OpenWeatherMap < ApplicationRecord

  store :data,
        accessors: %i[
          lat
          lon
          current
          hourly
          daily
          alerts
        ],
        coder: JSON
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
