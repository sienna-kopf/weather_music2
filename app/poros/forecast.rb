class Forecast
  attr_reader :city_name,
              :country_name,
              :sunrise_time,
              :sunset_time,
              :description,
              :temp,
              :temp_min,
              :temp_max,
              :pressure,
              :humidity,
              :visibility,
              :wind

  def initialize(forecast_info)
    @city_name = forecast_info[:name]
    @country_name = forecast_info[:sys][:country]
    @sunrise_time = forecast_info[:sys][:sunrise] ##make into real date
    @sunset_time = forecast_info[:sys][:sunset]
    @description = forecast_info[:weather][0][:description]
    @icon = forecast_info[:weather][0][:icon]
    @temp = forecast_info[:main][:temp].round(0)
    @temp_min = forecast_info[:main][:temp_min].round(0)
    @temp_max = forecast_info[:main][:temp_max].round(0)
    @pressure = forecast_info[:main][:pressure]
    @humidity = forecast_info[:main][:humidity]
    @visibility = forecast_info[:visibility]
    @wind = forecast_info[:wind][:speed]
  end
end
