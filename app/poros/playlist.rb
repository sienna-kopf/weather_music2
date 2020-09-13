class Playlist
  attr_reader :id,
              :uri

  def initialize(playlist_info)
    @id = playlist_info[:playlists][:items][0][:id]
    @uri = playlist_info[:playlists][:items][0][:uri]
  end
end
