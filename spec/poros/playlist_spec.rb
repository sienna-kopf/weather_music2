require 'spec_helper'

describe Forecast do
  it 'exists' do
    attrs = {:playlists=>
      {:items=>
        [
          {
          :id=>"1VT0GnhelpcB9qtnGo70rv",
          :uri=>"spotify:playlist:1VT0GnhelpcB9qtnGo70rv"
        }
        ]
      }
    }

    playlist = Playlist.new(attrs)

    expect(playlist).to be_a Playlist
    expect(playlist.id).to eq("1VT0GnhelpcB9qtnGo70rv")
    expect(playlist.uri).to eq("spotify:playlist:1VT0GnhelpcB9qtnGo70rv")
  end
end
