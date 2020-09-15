require 'faraday'
require 'dotenv'
Dotenv.load

class SpotifyService
  def playlist(token, weather)
    to_json("?q=#{weather}&type=playlist&limit=20&offset=5", token)
  end

  def create_playlist(target_valence, target_speech, target_mode, target_energy, target_tempo, seed_tracks, token)
    to_json_rec("?seed_tracks=#{seed_tracks}&target_valence=#{target_valence}&target_speechiness=#{target_speech}&target_energy=#{target_energy}&target_mode=#{target_mode}&target_tempo=#{target_tempo}", token)
  end

  def weather_tracks_first_50(token)
    to_json_tracks("?offset=1&limit=50", token)
  end

  # def weather_tracks_second_50(token)
  #   to_json_tracks("?offset=50&limit=50", token)
  # end
  #
  # def audio_features(uris, token)
  #   to_json_features("?ids=#{uris}", token)
  # end

  # def create_playlist(tracks, token)
  #   to_json_features("?ids=#{uris}", token)
  #
  # end

  private

  def conn(token)
    header = {
    Authorization: "Bearer #{token}"
    }
    acc = Faraday.new(url: 'https://api.spotify.com/v1/search', headers: header)
  end

  def conn_rec(token)
    header = {
    Authorization: "Bearer #{token}"
    }
    acc = Faraday.new(url: 'https://api.spotify.com/v1/recommendations', headers: header)
  end

  def to_json_rec(url, token)
    response = conn_rec(token).get(url)
    JSON.parse(response.body, symbolize_names: true)
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
