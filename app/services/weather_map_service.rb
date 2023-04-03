# frozen_string_literal: true

class WeatherMapService
  attr_accessor :lat, :lon, :api_key, :uri

  def initialize
    settings = MunicipalityService.settings
    return if settings[:openweathermap_api_key].blank?
    return if settings[:openweathermap_lat].blank?
    return if settings[:openweathermap_lon].blank?

    base_url = "https://api.openweathermap.org"
    @lat = settings[:openweathermap_lat]
    @lon = settings[:openweathermap_lon]
    @api_key = settings[:openweathermap_api_key]
    @uri = "#{base_url}/data/2.5/onecall?lat=#{lat}&lon=#{lon}&appid=#{api_key}&units=metric&exclude=minutely&lang=de"
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
