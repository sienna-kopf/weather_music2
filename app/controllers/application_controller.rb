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
      binding.pry
      client_device_response = SpotifyService.new.client_device_id(token)
      client_device_id = client_device_response[:devices][0][:id]

      forecast = Forecast.new(weather_response)
      max = 134.0
      min = 0.0
      val = forecast.temp.to_f

      response = SpotifyService.new.weather_tracks_first_50(token)
      song_ids = response[:items].map {|item| item[:track][:id]}.shuffle
      five_ids = song_ids.take(5)
      seed_tracks = five_ids.join(",")

      result = SpotifyService.new.create_playlist(target_valence(forecast), target_speech(forecast), target_mode(forecast), target_energy(forecast), target_tempo(forecast), seed_tracks, token)

      tracks = result[:tracks].map do |track|
        Track.new(track[:id])
      end

      WeatherMusicSerializer.new(forecast, tracks).data_hash.to_json
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

  # def playlist_success?(spotify_response)
  #   spotify_response[:playlists][:items].empty? == false
  # end

  def weather_success?(weather_response)
    weather_response[:cod] == 200
  end
end
