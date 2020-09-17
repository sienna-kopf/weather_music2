require 'spec_helper'

RSpec.describe SpotifyService do
  describe 'create track list method' do
    before :each do
      @token = "BQDsKNYViB8eif9EaYLOxfU6D3P54qIuyh6TUdJAP9asvGsUeHZjil5oWg_8WCdDfhT8Ue6nfHVPshD9ft2pRCzO25ZyyR2uvHmf3vSq2yE5gxkDaNoAqBmora8kFXXXmK_XsHUsIZEZthy6-3T6oHVOFafWG6aP1YCIKplJdwFRN1wxvjsD3H3Wl73lI0U4-0j7A4803fjMs8WsWSgDqBuJvOX2ofbpQP755U_dfIJpNtg"
      @playlist_id = "5YnwnP9mXOMAU0I8mP5WC2"
      @user_id = "bosigp0djzqxoyj6yq6sdzzaq"
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
    it 'generates 20 tracks based off of seed genres and target values' do
      VCR.use_cassette("sp_20_tracks_off_of_genres") do
        seed_genres = "house, dance, heavy_metal"
        track_list = @service.create_genre_track_list(0.5, 0.7, 1, 0.8, 80, seed_genres, @token)

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
    it 'pulls seed genres for sad path recommendations buy genre' do
      VCR.use_cassette("avaliable_genre_seeds") do
        response = @service.genres(@token)

        expect(response).to be_a Hash
        expect(response[:genres]).to be_an Array
        expect(response[:genres][0]).to eq("acoustic")
      end
    end
  end
end
