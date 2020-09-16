class Track
  attr_reader :id

  def initialize(result)
    @id = result[:id]
    @title = result[:name]
    @artist = result[:artists].first[:name]
  end
end
