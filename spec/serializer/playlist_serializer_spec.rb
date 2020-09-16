require 'spec_helper'

describe PlaylistSerializer do
  it 'data_hash' do
    playlist_external_url = "https://open.spotify.com/playlist/6NDVqBLyj2uRQkOGUSCYoa"
    playlist_status = 201

    playlist_response = PlaylistSerializer.new(playlist_external_url, playlist_status).data_hash

    expect(playlist_response).to be_a Hash
    expect(playlist_response[:data][:playlist][:attributes]).to have_key :status
    expect(playlist_response[:data][:playlist][:attributes]).to have_key :external_url
  end
end
