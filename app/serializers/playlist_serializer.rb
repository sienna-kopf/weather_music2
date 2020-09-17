class PlaylistSerializer

  def initialize(status, external_url)
    @status = status
    @external_url = external_url
  end

  def data_hash
    {
      data:
      {
        playlist: {
          type: 'playlist',
          attributes: {
            status: @status.as_json,
            external_url: @external_url.as_json
          }
        }
      }
    }
  end
end
