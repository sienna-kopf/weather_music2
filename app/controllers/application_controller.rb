require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    erb :welcome
  end

  # def serialization(weather_response, token)
  #   if weather_success?(weather_response)
  #     binding.pry
  #     forecast = Forecast.new(weather_response)
  #
  #     spotify_response = SpotifyService.new.playlist(token, forecast.main_description)
  #     playlist = spotify_response[:playlists][:items].shuffle.first
  #     if playlist_success?(spotify_response)
  #       WeatherMusicSerializer.new(forecast, Playlist.new(playlist)).data_hash.to_json
  #     else
  #       WeatherMusicSerializer.new.no_playlist_response.to_json
  #     end
  #   else
  #     WeatherMusicSerializer.new.no_city_response.to_json
  #   end
  # end

  def serialization(weather_response, token)
    if weather_success?(weather_response)
      forecast = Forecast.new(weather_response)
      response_1 = SpotifyService.new.weather_tracks_first_50(token)
      response_1_ids = response_1[:items].map {|item| item[:track][:id]}
      if response_1[:total] > 50
        response_2 = SpotifyService.new.weather_tracks_second_50(token)
        response_2_ids= response_2[:items].map {|item| item[:track][:id]}
        all_ids = response_1_ids + response_2_ids
      else
        all_ids = response_1_ids
      end
      query = all_ids.join(",")

      audio_features_data = SpotifyService.new.audio_features(query, token)
      max = 134.0
      min = 0.0
      val = forecast.temp.to_f

      normalized_temp = [0, [1, (val - min) / (max - min)].min].max

      sorted_by_valence_hash = audio_features_data[:audio_features].sort_by do |song|
        (song[:valence] - normalized_temp).abs
      end.take(20)

      song_ids = sorted_by_valence_hash.map do |song|
        song[:id]
      end

      tracks = song_ids.map do |id|
        Track.new(id)
      end

      binding.pry

      WeatherMusicSerializer.new(forecast, tracks).data_hash.to_json
    else
      WeatherMusicSerializer.new.no_city_response.to_json
    end
  end
  #
  # def test
  #   # total_tracks = response_1[:total]
  #   response_1 = SpotifyService.new.weather_tracks_first_50(token)
  #   response_2 = SpotifyService.new.weather_tracks_second_50(token)
  #   response_1_ids = response_1[:items].map {|item| item[:track][:id]}
  #   response_2_ids= response_2[:items].map {|item| item[:track][:id]}
  #   all_ids = response_1_ids+ response_2_ids
  #   query = all_ids.join(",")
  #   audio_features_data = SpotifyService.new.audio_features(query, token)
  #
  # end

  def playlist_success?(spotify_response)
    spotify_response[:playlists][:items].empty? == false
  end

  def weather_success?(weather_response)
    weather_response[:cod] == 200
  end
end
