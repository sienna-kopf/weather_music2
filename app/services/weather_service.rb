require 'faraday'
require 'dotenv'
Dotenv.load

class WeatherService
  def forecast(location)
    to_json("/data/2.5/weather?units=imperial&q=#{location}")
  end

  private

  def conn
    Faraday.new('https://api.openweathermap.org') do |f|
      f.params[:appid] = "#{ENV['WEATHER_API_KEY']}"
    end
  end

  def to_json(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end
end
