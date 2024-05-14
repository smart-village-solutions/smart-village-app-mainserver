# frozen_string_literal: true

class WeatherMapService
  attr_accessor :lat, :lon, :api_key, :uri

  def initialize
    return if Rails.application.credentials.openweathermap.blank?

    base_url = "https://api.openweathermap.org"
    @lat = Rails.application.credentials.openweathermap[:lat]
    @lon = Rails.application.credentials.openweathermap[:lon]
    @api_key = Rails.application.credentials.openweathermap[:api_key]
    @uri = "#{base_url}/data/3.0/onecall?lat=#{lat}&lon=#{lon}&appid=#{api_key}&units=metric&exclude=minutely&lang=de"
  end

  # Delete old weather data and import new wether data from
  # http://api.openweathermap.org
  #
  # @return [OpenWeatherMap] latest created OpenWeatherMap object
  def import
    return nil if lat.blank? || lon.blank? || api_key.blank?

    request_service = ApiRequestService.new(uri)
    result = request_service.get_request

    return nil if result.blank?
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
