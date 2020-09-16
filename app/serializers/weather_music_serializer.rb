class WeatherMusicSerializer

  def initialize(forecast = nil, tracks = nil)
    @forecast = forecast
    @tracks = tracks
  end

  def data_hash
    {
      data:
      {
        weather:
        {
          type: 'forecast',
          attributes: @forecast.as_json
          }
        },
        {
          music:
          {
            type: 'tracks',
            attributes: @tracks.as_json
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
end
