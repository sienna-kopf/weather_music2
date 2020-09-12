require './config/environment'
require 'dotenv'
Dotenv.load

class WeatherMusicController < ApplicationController
  before do
    content_type 'application/json'
  end

  get "/weather_playlist" do
    token = params[:token]
    location = params[:q]
    weather_response = WeatherService.new.forecast(location)
    if weather_response[:cod] == 200
      forecast = Forecast.new(weather_response)
      spotify_response = SpotifyService.new.playlist(token, forecast.description)
      WeatherMusicSerializer.new(forecast).data_hash.to_json
    else
      WeatherMusicSerializer.new.no_response.to_json
    end
  end
end
