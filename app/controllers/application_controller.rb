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
        if user_tracks(token)[:items].count < 5
          genre_route(token, forecast(weather_response))
        else
          songs_route(token, forecast(weather_response), user_tracks(token))
        end
    else
      WeatherMusicSerializer.new.no_city_response.to_json
    end
  end

  #playlist methods

  def playlist(playlist_name, user_id, tracks_collection, token)
    serialize_playlist(fill_playlist(playlist_name, user_id, tracks_collection, token), create_playlist(playlist_name, user_id, token))
  end

  def fill_playlist(playlist_name, user_id, tracks_collection, token)
    SpotifyService.new.fill_playlist(
      create_playlist(playlist_name, user_id, token)[:id],
      parse_tracks(tracks_collection),
      token)
  end

  def create_playlist(playlist_name, user_id, token)
    SpotifyService.new.create_playlist(playlist_name, user_id, token)
  end

  #routes based on user library methods

  def genre_route(token, forecast)
    seed_genres = SpotifyService.new.genres(token)[:genres].shuffle.take(5).join(",")
    result = SpotifyService.new.create_genre_track_list(target_valence(forecast), target_speech(forecast), target_mode(forecast), target_energy(forecast), target_tempo(forecast), seed_genres, token)
    serialize_weather_music(forecast, result)
  end

  def songs_route(token, forecast, response)
    seed_tracks = response[:items].map {|item| item[:track][:id]}.shuffle.take(5).join(",")
    result = SpotifyService.new.create_track_list(target_valence(forecast), target_speech(forecast), target_mode(forecast), target_energy(forecast), target_tempo(forecast), seed_tracks, token)
    serialize_weather_music(forecast, result)
  end

  #helper methods

  def parse_tracks(tracks_collection)
    JSON.parse(tracks_collection).join(",")
  end

  def serialize_weather_music(forecast, result)
    WeatherMusicSerializer.new(forecast, create_tracks(result)).data_hash.to_json
  end

  def create_tracks(result)
    result[:tracks].map do |data|
      Track.new(data)
    end
  end

  def user_tracks(token)
    SpotifyService.new.weather_tracks_first_50(token)
  end

  def weather_success?(weather_response)
    weather_response[:cod] == 200
  end

  def serialize_playlist(status, new_playlist)
    PlaylistSerializer.new(status, new_playlist[:external_urls][:spotify]).data_hash.to_json
  end

  def forecast(weather_response)
    Forecast.new(weather_response)
  end

  #weather methods

  def normalization_formula(min, max, val)
    [0, [1, (val - min) / (max - min)].min].max
  end

  def average(val_1, val_2)
    (val_1 + val_2) / 2
  end

  def minor_or_major(target)
    target < 0.5 ? 0 : 1
  end

  def target_valence(forecast)
    max = 116.0
    min = 0.0
    normalization_formula(max, min, forecast.temp.to_f).round(1)
  end

  def target_speech(forecast)
    max = 36.0
    min = 0.0
    normalization_formula(max, min, forecast.wind).round(1)
  end

  def target_mode(forecast)
    max_temp = 134.0
    min_temp = 0.0
    target_temp = normalization_formula(max_temp, min_temp, forecast.temp.to_f)
    max_humidity = 0.0
    min_humidity = 100.0
    target_humidity = normalization_formula(max_humidity, min_humidity, forecast.humidity.to_f)
    minor_or_major(average(target_temp, target_humidity))
  end

  def target_energy(forecast)
    max_temp = 134.0
    min_temp = 0.0
    target_temp = normalization_formula(max_temp, min_temp, forecast.temp.to_f)
    max_humidity = 0.0
    min_humidity = 100.0
    target_humidity = normalization_formula(max_humidity, min_humidity, forecast.humidity.to_f)
    average(target_temp, target_humidity).round(1)
  end

  def target_tempo(forecast)
    max = 36.0
    min = 0.0
    target_temp = normalization_formula(max, min, forecast.wind)
    ratio_scale(target_temp, 480).round(2)
  end

  def ratio_scale(decimal, range)
    decimal * range
  end
end
