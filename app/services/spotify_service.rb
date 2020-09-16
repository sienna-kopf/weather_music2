require 'faraday'
require 'dotenv'
Dotenv.load

class SpotifyService
  def create_track_list(target_valence, target_speech, target_mode, target_energy, target_tempo, seed_tracks, token)
    to_json_rec("?seed_tracks=#{seed_tracks}&target_valence=#{target_valence}&target_speechiness=#{target_speech}&target_energy=#{target_energy}&target_mode=#{target_mode}&target_tempo=#{target_tempo}", token)
  end

  def weather_tracks_first_50(token)
    to_json_tracks("?offset=1&limit=50", token)
  end

  def create_playlist(playlist_name, user_id, token)
    conn_user(token, playlist_name, user_id)
  end

  def fill_playlist(playlist_id, track_uris, token)
    conn_playlist(playlist_id, track_uris, token)
  end

  private

  def conn_rec(token)
    header = {
    Authorization: "Bearer #{token}"
    }
    acc = Faraday.new(url: 'https://api.spotify.com/v1/recommendations', headers: header)
  end

  def conn_library(token)
    header = {
    Authorization: "Bearer #{token}"
    }
    acc = Faraday.new(url: 'https://api.spotify.com/v1/me/tracks', headers: header)
  end

  def conn_user(token, playlist_name, user_id)
    conn = Faraday.new
    response = conn.post do |req|
      req.url "https://api.spotify.com/v1/users/#{user_id}/playlists"
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{token}"
      req.body = { "name": "#{playlist_name}", "public": false }.to_json
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  def conn_playlist(playlist_id, track_uris, token)
    conn = Faraday.new
    response = conn.post do |req|
      req.url "https://api.spotify.com/v1/playlists/#{playlist_id}/tracks"
      req.params['uris'] = "#{track_uris}"
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{token}"
    end
    response.status
  end

  def to_json_rec(url, token)
    response = conn_rec(token).get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def to_json_tracks(url, token)
    response = conn_library(token).get(url)
    JSON.parse(response.body, symbolize_names: true)
  end
end
