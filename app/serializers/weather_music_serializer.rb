class WeatherMusicSerializer

  def initialize(forecast = nil, tracks = nil)
    @forecast = forecast
    @tracks = tracks.map {|track| track.id}
  end

  def data_hash
    {
      "data": {
        "weather": {
          "type": "forecast",
          "attributes": {
            "city_name": @forecast.city_name,
            "country_name": @forecast.country_name,
            "sunrise_time": @forecast.sunrise_time,
            "sunset_time": @forecast.sunset_time,
            "description": @forecast.description,
            "main_description": @forecast.main_description,
            "temp": @forecast.temp,
            "temp_min": @forecast.temp_min,
            "temp_max": @forecast.temp_max,
            "pressure": @forecast.pressure,
            "humidity": @forecast.humidity,
            "visibility": @forecast.visibility,
            "wind": @forecast.wind,
            "icon": @forecast.icon
          }
        },
        "music": {
          "type": "track_ids",
          "attributes": {
            "ids": @tracks
          }
        }
      }
    }
  end

  def no_city_response
    {
      "data": {
        "type": "error",
        "attributes": {
          "code": 404,
          "message": "city_not_found"
        }
      }
    }
  end

  def no_playlist_response
    {
      "data": {
        "type": "error",
        "attributes": {
          "code": 404,
          "message": "playlist_not_found"
        }
      }
    }
  end
end
