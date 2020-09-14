require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    erb :welcome
  end

  def serialization(weather_response, token)
    if weather_success?(weather_response)
      forecast = Forecast.new(weather_response)
      spotify_response = SpotifyService.new.playlist(token, forecast.main_description)
      playlist = spotify_response[:playlists][:items].shuffle.first
      if playlist_success?(spotify_response)
        WeatherMusicSerializer.new(forecast, Playlist.new(playlist)).data_hash.to_json
      else
        WeatherMusicSerializer.new.no_playlist_response.to_json
      end
    else
      WeatherMusicSerializer.new.no_city_response.to_json
    end
  end

  def playlist_success?(spotify_response)
    spotify_response[:playlists][:items].empty? == false
  end

  def weather_success?(weather_response)
    weather_response[:cod] == 200
  end
end
