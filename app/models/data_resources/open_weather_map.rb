# frozen_string_literal: true

class OpenWeatherMap < ApplicationRecord
  include MunicipalityScope

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

  belongs_to :municipality
end

# == Schema Information
#
# Table name: open_weather_maps
#
#  id              :bigint           not null, primary key
#  data            :text(65535)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  municipality_id :integer
#
