# frozen_string_literal: true

class WeatherMapService
  attr_accessor :uri

  def initialize
    return if Settings.openweathermap.blank?

    lat = Settings.openweathermap[:lat]
    lon = Settings.openweathermap[:lon]
    api_key = Settings.openweathermap[:api_key]
    base_url = "https://api.openweathermap.org"

    @uri = "#{base_url}/data/2.5/onecall?lat=#{lat}&lon=#{lon}&appid=#{api_key}&units=metric&exclude=minutely&lang=de"
  end

  # Delete old weather data and import new wether data from
  # http://api.openweathermap.org
  #
  # @return [OpenWeatherMap] latest created OpenWeatherMap object
  def import
    request_service = ApiRequestService.new(uri)
    result = request_service.get_request

    return nil unless result.code == "200"
    return nil if result.body.blank?

    weather_map = nil
    OpenWeatherMap.transaction do
      OpenWeatherMap.destroy_all
      weather_map = OpenWeatherMap.create(data: JSON.parse(result.body))
    end

    weather_map
  end
end
