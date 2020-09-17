require 'spec_helper'

RSpec.describe SpotifyService do
  describe 'create track list method' do
    before :each do
      @token = "BQBggPQkOHz1gE6KSpSOdEdIqgzx5tkEpvBZk6Yq9DFs5uIuNJR7_sbWydi_azoWYMG3GRGGkaANkzb6dSo3vmQFapIgHJcDVSBqi4NJ2S80d9Zo5W85V2JDozobA9Xsn4Q-DjfRBF40jMyGXewWlnG_s8bGY5ZhwfIsdYSuCyV9Cak0Y2nngE4TaeucKMiOkNvrW_PnufHbyV6GbgfPzQtobUM"
      @playlist_id = "0HvaOJCC9uESRn04SwVIf9"
      @user_id = "1270051882"
      @service = SpotifyService.new
    end
    it 'generates 20 tracks based off of seed tracks and target values' do
      VCR.use_cassette("sp_20_tracks") do
        st = "5hTpBe8h35rJ67eAWHQsJx,6LcauUZjF1eXQrgqMUecHX,7sO5G9EABYOXQKNPNiE9NR,7IBSffWIu7P2MC7kMwy2FM,6URlKrAIlJJwHnHxxXWywt"
        track_list = @service.create_track_list(0.5, 0.7, 1, 0.8, 80, st, @token)

        expect(track_list).to be_a(Hash)
        expect(track_list[:tracks]).to be_an(Array)
        expect(track_list[:tracks].size).to eq(20)
        first_track = track_list[:tracks][0]
        expect(first_track).to have_key :uri
        expect(first_track).to have_key :name
        expect(first_track[:artists][0]).to have_key :name
      end
    end
    it 'pulls 50 tracks from your saved library' do
      VCR.use_cassette("50_library") do
        library_tracks = @service.weather_tracks_first_50(@token)

        expect(library_tracks).to be_a(Hash)
        expect(library_tracks[:items]).to be_an(Array)
        first_track = library_tracks[:items][0][:track]
        expect(first_track).to have_key :uri
        expect(first_track).to have_key :name
        expect(first_track[:artists][0]).to have_key :name
      end
    end
    it 'creates an empty playlist for user' do
      VCR.use_cassette("empty_playlist") do
        name = "party time"
        playlist = @service.create_playlist(name, @user_id, @token)

        expect(playlist).to be_a(Hash)
        expect(playlist[:external_urls]).to have_key :spotify
        expect(playlist).to have_key :id
        expect(playlist).to have_key :name
        expect(playlist[:name]).to eq(name)
      end
    end
    it 'builds playlist with 20 tracks' do
      VCR.use_cassette("build_playlist") do
        track_uris = "spotify:track:4aOjDKk1s5hlsEY5ZhhX3l,spotify:track:12G1TYIfbpvC0mdFFn4Pbg,spotify:track:5LxvwujISqiB8vpRYv887S,spotify:track:3ZgQhe1Sv7mnQjpVTJnOFp,spotify:track:6gJdDnF2TzfA1WPMXuCa3x,spotify:track:3kk66lcmo2blwB1uLHMkPJ,spotify:track:3vkQ5DAB1qQMYO4Mr9zJN6,spotify:track:1i0kVfX5LdEdo52St39QM0,spotify:track:0XRbYXQUymj9SJkrr8YK5B,spotify:track:5jbKpvtoxZB14tbnBafMuL,spotify:track:7KFThZQCAcj8JXdPRtdrXE,spotify:track:3EYOJ48Et32uATr9ZmLnAo,spotify:track:1x9iOd3K1JC6tdjGZJpFgZ,spotify:track:0QeI79sp1vS8L3JgpEO7mD,spotify:track:4qan0qNCFAEu6A2hcwPETn,spotify:track:4uNFNCCK5O3mtUJ6gcW9Gx,spotify:track:0hioWv2FDtVePjHFTwgrf7,spotify:track:0LWkaEyQRkF0XAms8Bg1fC,spotify:track:2vytyWClpsahqcL6NibSE3,spotify:track:1jRzdY7oUBOhrylNtiMtBD"
        status = @service.fill_playlist(@playlist_id, track_uris, @token)

        expect(status).to eq(201)
      end
    end
  end
end
