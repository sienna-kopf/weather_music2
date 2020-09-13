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
      spotify_response = SpotifyService.new.playlist(token, forecast.main_description)
      unless spotify_response[:playlists][:items].empty?
        playlist = Playlist.new(spotify_response)
        WeatherMusicSerializer.new(forecast, playlist).data_hash.to_json
      else
        WeatherMusicSerializer.new.no_playlist_response.to_json
      end
    else
      WeatherMusicSerializer.new.no_city_response.to_json
    end
  end
end
