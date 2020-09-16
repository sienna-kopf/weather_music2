require 'spec_helper'

describe Track do
  it 'exists' do
    attrs = {
          :uri => "spotify:playlist:1VT0GnhelpcB9qtnGo70rv",
          :name => "Comfortably Numb",
          :artists => [
            {
              :name => "Pink Floyd"
            }
          ]
        }

    track = Track.new(attrs)

    expect(track).to be_a Track
    expect(track.uri).to eq("spotify:playlist:1VT0GnhelpcB9qtnGo70rv")
    expect(track.title).to eq("Comfortably Numb")
    expect(track.artist).to eq("Pink Floyd")
  end
end
