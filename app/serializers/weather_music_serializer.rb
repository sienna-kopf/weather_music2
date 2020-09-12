class WeatherMusicSerializer

  def initialize(forecast = nil)
    @forecast = forecast
  end

  def data_hash
    {
       city_name: @forecast.city_name,
       country_name: @forecast.country_name,
       sunrise_time: @forecast.sunrise_time,
       sunset_time: @forecast.sunset_time,
       description: @forecast.description,
       temp: @forecast.temp,
       temp_min: @forecast.temp_min,
       temp_max: @forecast.temp_max,
       pressure: @forecast.pressure,
       humidity: @forecast.humidity,
       visibility: @forecast.visibility,
       wind: @forecast.wind
      }
  end

  def no_response
    {
      code: 404,
      message: "city_not_found"
    }
  end
end
