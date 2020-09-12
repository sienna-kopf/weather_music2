require './config/environment'
require 'dotenv'
Dotenv.load

class WeatherMusicController < ApplicationController
  before do
     content_type 'application/json'
   end

  get "/weather_playlist" do
    location = params[:q]
    weather_response = WeatherService.new.forecast(location)
    forecast = Forecast.new(weather_response)
    json_hash = WeatherMusicSerializer.new(forecast).data_hash.to_json
  end
end
