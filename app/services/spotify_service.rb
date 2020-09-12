require 'faraday'
require 'dotenv'
Dotenv.load

class SpotifyService
  def playlist(access_token, refresh_token, weather)
    to_json("?q=#{weather}&type=playlist&market=US&limit=1&offset=5", access_token)
  end

  private

  def conn(access_token) 
    header = {
    Authorization: "Bearer #{access_token}"
    }
    acc = Faraday.new(url: 'https://api.spotify.com/v1/search', headers: header)
  end
  
  def to_json(url, access_token)
    response = conn(access_token).get(url)
    binding.pry
    JSON.parse(response.body, symbolize_names: true)
  end
end
