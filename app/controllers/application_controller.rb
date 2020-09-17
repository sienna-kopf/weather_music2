require './config/environment'

class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    erb :welcome
  end

  def playlist(location, weather_description, user_id, tracks_collection, token)
    playlist_name = "its a great day for #{weather_description} weather in #{location}"
    new_playlist = SpotifyService.new.create_playlist(playlist_name, user_id, token)
    playlist_id = new_playlist[:id]
    playlist_external_url = new_playlist[:external_urls][:spotify]
    track_uris = JSON.parse(tracks_collection).join(",")
    filled_playlist_status = SpotifyService.new.fill_playlist(playlist_id, track_uris, token)
    PlaylistSerializer.new(filled_playlist_status, playlist_external_url).data_hash.to_json
  end

  def serialization(weather_response, token)
    if weather_success?(weather_response)
      tracks = make_weather_setlist(token)
      if tracks.count < 5
        tracks = genre_route(token, Forecast.new(weather_response))
      else
        tracks = songs_route(token, Forecast.new(weather_response), tracks)
      end
        WeatherMusicSerializer.new(Forecast.new(weather_response), tracks).data_hash.to_json
    else
      WeatherMusicSerializer.new.no_city_response.to_json
    end
  end

  def target_valence(forecast)
    max = 116.0
    min = 0.0
    val = forecast.temp.to_f
    [0, [1, (val - min) / (max - min)].min].max.round(1)
  end

  def target_speech(forecast)
    max = 36.0
    min = 0.0
    val = forecast.wind
    [0, [1, (val - min) / (max - min)].min].max.round(1)
  end

  def target_mode(forecast)
    max_temp = 134.0
    min_temp = 0.0
    temp_val = forecast.temp.to_f
    target_temp = [0, [1, (temp_val - min_temp) / (max_temp - min_temp)].min].max

    max_humidity = 0.0
    min_humidity = 100.0
    humidity_val = forecast.humidity.to_f
    target_humidity = [0, [1, (humidity_val - min_humidity) / (max_humidity - min_humidity)].min].max
    target = ((target_temp + target_humidity) / 2)
    if target < 0.5
      return 0
    else
      return 1
    end
  end

  def target_energy(forecast)
    max_temp = 134.0
    min_temp = 0.0
    temp_val = forecast.temp.to_f
    target_temp = [0, [1, (temp_val - min_temp) / (max_temp - min_temp)].min].max

    max_humidity = 0.0
    min_humidity = 100.0
    humidity_val = forecast.humidity.to_f
    target_humidity = [0, [1, (humidity_val - min_humidity) / (max_humidity - min_humidity)].min].max
    ((target_temp + target_humidity) / 2).round(1)
  end

  def target_tempo(forecast)
    max = 36.0
    min = 0.0
    val = forecast.wind
    target_temp = [0, [1, (val - min) / (max - min)].min].max
    range = 480
    (target_temp * range).round(2)
  end

  def weather_success?(weather_response)
    weather_response[:cod] == 200
  end

  def genre_route(token, forecast)
    genres = SpotifyService.new.genres(token)
    genres = genres[:genres].shuffle.take(5)
    seed_genres = genres.join(",")
    result = SpotifyService.new.create_genre_track_list(target_valence(forecast), target_speech(forecast), target_mode(forecast), target_energy(forecast), target_tempo(forecast), seed_genres, token)
    tracks = make_tracks(result[:tracks])
  end

  def songs_route(token, forecast, response)
    song_ids = response[:items].map {|item| item[:track][:id]}.shuffle
    five_ids = song_ids.take(5)
    seed_tracks = five_ids.join(",")
    result = SpotifyService.new.create_track_list(target_valence(forecast), target_speech(forecast), target_mode(forecast), target_energy(forecast), target_tempo(forecast), seed_tracks, token)
    tracks = make_tracks(result[:tracks])
  end

  def make_weather_setlist(token)
    response = SpotifyService.new.weather_tracks_first_50(token)
  end

  def make_tracks(songs)
    tracks = songs.map do |data|
      Track.new(data)
    end
  end
end
