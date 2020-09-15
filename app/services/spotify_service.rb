require 'faraday'
require 'dotenv'
Dotenv.load

class SpotifyService
  def playlist(token, weather)
    to_json("?q=#{weather}&type=playlist&limit=20&offset=5", token)
  end

  def weather_tracks_first_50(token)
    to_json_tracks("?offset=1&limit=50", token)
  end

  def weather_tracks_second_50(token)
    to_json_tracks("?offset=50&limit=50", token)
  end

  def audio_features(uris, token)
    binding.pry
    to_json_features("?#{uris}", token)
  end

  private

  def conn(token)
    header = {
    Authorization: "Bearer #{token}"
    }
    acc = Faraday.new(url: 'https://api.spotify.com/v1/search', headers: header)
  end

  def conn_library(token)
    header = {
    Authorization: "Bearer #{token}"
    }
    acc = Faraday.new(url: 'https://api.spotify.com/v1/me/tracks', headers: header)
  end

  def conn_features(token)
    header = {
    Authorization: "Bearer #{token}"
    }
    acc = Faraday.new(url: 'https://api.spotify.com/v1/audio-features', headers: header)
  end

  def to_json(url, token)
    response = conn(token).get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def to_json_tracks(url, token)
    response = conn_library(token).get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def to_json_features(url, token)
    response = conn_features(token).get(url)
    JSON.parse(response.body, symbolize_names: true)
  end
end
