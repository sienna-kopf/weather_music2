class Track
  attr_reader :uri,
              :title,
              :artist

  def initialize(result)
    @uri = result[:uri]
    @title = result[:name]
    @artist = result[:artists].first[:name]
  end
end
