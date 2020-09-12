require './config/environment'
require 'dotenv'
Dotenv.load

class WeatherMusicController < ApplicationController
  before do
    content_type 'application/json'
  end

  get "/weather_playlist" do
    access_token = params[:access_token]
    refresh_token = params[:refresh_token]
    location = params[:q]
    weather_response = WeatherService.new.forecast(location)
    binding.pry
    if weather_response[:cod] == 200
      forecast = Forecast.new(weather_response)
      weather = forecast.description
      spotify_response = SpotifyService.new.playlist(access_token, refresh_token, weather)
      binding.pry
      WeatherMusicSerializer.new(forecast).data_hash.to_json
    else
      WeatherMusicSerializer.new.no_response.to_json
    end
  end
end
