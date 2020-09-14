class Playlist
  attr_reader :id,
              :uri

  def initialize(playlist_info)
    @id = playlist_info[:id]
    @uri = playlist_info[:uri]
  end
end
