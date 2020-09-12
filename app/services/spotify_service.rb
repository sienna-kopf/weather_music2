require 'faraday'
require 'dotenv'
Dotenv.load

class SpotifyService
  def playlist(token, weather)
    to_json("?q=#{weather}&type=playlist&market=US&limit=1&offset=5", token)
  end

  private

  def conn(token)
    header = {
    Authorization: "Bearer #{token}"
    }
    acc = Faraday.new(url: 'https://api.spotify.com/v1/search', headers: header)
  end

  def to_json(url, token)
    response = conn(token).get(url)
    JSON.parse(response.body, symbolize_names: true)
  end
end
