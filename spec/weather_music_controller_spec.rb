require_relative "spec_helper"

def app
  WeatherMusicController
end

describe WeatherMusicController do
  before :each do
    @token = "BQDdAPDPDGyotHHjwslG4XY-nJ59bLCmKfYp2SVo6jUz_ItI2lbPGdncNrx6ajcCsO60RnjwA5MPiYNg20Aupr3KmxVW1OVKLJeZaxcjCW2GzSJtXUks4lS6wQ19cMk7BB5WTVj5mdnJ0_981L6zA5CAHlqgACaXdI9MBuhoTkb0IZEXhHYrbBgMUFUQBPODn9u6epU7d6Vl1ApFVWSka5cK-ck"
    @user_id = "1270051882"
  end

      it "returns current weather data for a particular location city, state, country", :vcr do
          location = "denver, co, usa"
          get "/weather_playlist?units=imperial&q=#{location}&token=#{@token}"

          expect(last_response).to be_successful
          last_response.content_type == "application/json"

          weather = JSON.parse(last_response.body, symbolize_names: true)

          expect(weather).to be_a Hash
          expect(weather[:data][:weather][:attributes]).to have_key :city_name
          expect(weather[:data][:weather][:attributes]).to have_key  :country_name
          expect(weather[:data][:weather][:attributes]).to have_key  :sunrise_time
          expect(weather[:data][:weather][:attributes]).to have_key  :sunset_time
          expect(weather[:data][:weather][:attributes]).to have_key  :temp_min
          expect(weather[:data][:weather][:attributes]).to have_key  :temp_max
          expect(weather[:data][:weather][:attributes]).to have_key  :pressure
          expect(weather[:data][:weather][:attributes]).to have_key  :humidity
          expect(weather[:data][:weather][:attributes]).to have_key  :visibility
          expect(weather[:data][:weather][:attributes]).to have_key  :wind
          expect(weather[:data][:weather][:attributes]).to have_key  :main_description
          expect(weather[:data][:weather][:attributes]).to have_key  :icon

          expect(weather[:data][:music][:attributes][0]).to have_key  :uri
          expect(weather[:data][:music][:attributes][0]).to have_key  :title
          expect(weather[:data][:music][:attributes][0]).to have_key  :artist

          expect(weather[:data][:weather][:attributes][:city_name]).to eq ("Denver")
          expect(weather[:data][:weather][:attributes][:country_name]).to eq ("US")
      end

      it "returns current weather data for a particular location city, country", :vcr do
          location = "santiago, chi"
          get "/weather_playlist?units=imperial&q=#{location}&token=#{@token}"

          expect(last_response).to be_successful
          last_response.content_type == "application/json"

          weather = JSON.parse(last_response.body, symbolize_names: true)
          expect(weather).to be_a Hash
          expect(weather[:data][:weather][:attributes]).to have_key  :city_name
          expect(weather[:data][:weather][:attributes]).to have_key  :country_name
          expect(weather[:data][:weather][:attributes]).to have_key  :sunrise_time
          expect(weather[:data][:weather][:attributes]).to have_key  :sunset_time
          expect(weather[:data][:weather][:attributes]).to have_key  :temp_min
          expect(weather[:data][:weather][:attributes]).to have_key  :temp_max
          expect(weather[:data][:weather][:attributes]).to have_key  :pressure
          expect(weather[:data][:weather][:attributes]).to have_key  :humidity
          expect(weather[:data][:weather][:attributes]).to have_key  :visibility
          expect(weather[:data][:weather][:attributes]).to have_key  :wind
          expect(weather[:data][:weather][:attributes]).to have_key  :main_description
          expect(weather[:data][:weather][:attributes]).to have_key  :icon

          expect(weather[:data][:music][:attributes][0]).to have_key  :uri
          expect(weather[:data][:music][:attributes][0]).to have_key  :title
          expect(weather[:data][:music][:attributes][0]).to have_key  :artist

          expect(weather[:data][:weather][:attributes][:city_name]).to eq ("Santiago")
          expect(weather[:data][:weather][:attributes][:country_name]).to eq ("CL")
      end

      it "returns current weather data for a particular location city", :vcr do
          location = "salt lake city"
          get "/weather_playlist?units=imperial&q=#{location}&token=#{@token}"

          expect(last_response).to be_successful
          last_response.content_type == "application/json"

          weather = JSON.parse(last_response.body, symbolize_names: true)

          expect(weather).to be_a Hash
          expect(weather[:data][:weather][:attributes]).to have_key  :city_name
          expect(weather[:data][:weather][:attributes]).to have_key  :country_name
          expect(weather[:data][:weather][:attributes]).to have_key  :sunrise_time
          expect(weather[:data][:weather][:attributes]).to have_key  :sunset_time
          expect(weather[:data][:weather][:attributes]).to have_key  :temp_min
          expect(weather[:data][:weather][:attributes]).to have_key  :temp_max
          expect(weather[:data][:weather][:attributes]).to have_key  :pressure
          expect(weather[:data][:weather][:attributes]).to have_key  :humidity
          expect(weather[:data][:weather][:attributes]).to have_key  :visibility
          expect(weather[:data][:weather][:attributes]).to have_key  :wind
          expect(weather[:data][:weather][:attributes]).to have_key  :main_description
          expect(weather[:data][:weather][:attributes]).to have_key  :icon

          expect(weather[:data][:music][:attributes][0]).to have_key  :uri
          expect(weather[:data][:music][:attributes][0]).to have_key  :title
          expect(weather[:data][:music][:attributes][0]).to have_key  :artist

          expect(weather[:data][:weather][:attributes][:city_name]).to eq ("Salt Lake City")
          expect(weather[:data][:weather][:attributes][:country_name]).to eq ("US")
      end

      it "returns an error message if location cannot be found", :vcr do
          location = "aowfufrbjna"
          get "/weather_playlist?units=imperial&q=#{location}&token=#{@token}"

          expect(last_response).to be_successful
          last_response.content_type == "application/json"

          error = JSON.parse(last_response.body, symbolize_names: true)

          expect(error).to be_a Hash
          expect(error[:data][:attributes]).to have_key :code
          expect(error[:data][:attributes]).to have_key :message
          expect(error[:data][:attributes][:code]).to eq(404)
          expect(error[:data][:attributes][:message]).to eq("city_not_found")
        end

      it "pulls tracks based on genre if user has no saved tracks", :vcr do
          token = "BQBiuYeSi3oRvtDjt_PFPUFLG5o8_dYuUrt4Rx5vh3WaN87liT1VJTW2kIGvz5aKp-gA5m7YvMcOTENsrU2NDkxD6il7a0qUVRujxN6AUcoRPNYh4Y8C99ymVAsUW58u3BNJhL0r7975vhVKluFXtrBUXJOWJz34Z_JFUvRx3Oh-M5P6NNx9NnfXQHQuzRBSFF4oVbVmOEbEr6ylnCTyUhrYiq4mUDyhNDxUMQYWfxA"
          location = "denver"
          get "/weather_playlist?units=imperial&q=#{location}&token=#{token}"

          expect(last_response).to be_successful
          last_response.content_type == "application/json"

          weather_music = JSON.parse(last_response.body, symbolize_names: true)

          expect(weather_music).to be_a Hash
          expect(weather_music[:data][:weather][:attributes]).to have_key  :city_name
          expect(weather_music[:data][:weather][:attributes]).to have_key  :country_name
          expect(weather_music[:data][:weather][:attributes]).to have_key  :sunrise_time
          expect(weather_music[:data][:weather][:attributes]).to have_key  :sunset_time
          expect(weather_music[:data][:weather][:attributes]).to have_key  :temp_min
          expect(weather_music[:data][:weather][:attributes]).to have_key  :temp_max
          expect(weather_music[:data][:weather][:attributes]).to have_key  :pressure
          expect(weather_music[:data][:weather][:attributes]).to have_key  :humidity
          expect(weather_music[:data][:weather][:attributes]).to have_key  :visibility
          expect(weather_music[:data][:weather][:attributes]).to have_key  :wind
          expect(weather_music[:data][:weather][:attributes]).to have_key  :main_description
          expect(weather_music[:data][:weather][:attributes]).to have_key  :icon

          expect(weather_music[:data][:music][:attributes][0]).to have_key  :uri
          expect(weather_music[:data][:music][:attributes][0]).to have_key  :title
          expect(weather_music[:data][:music][:attributes][0]).to have_key  :artist

          expect(weather_music[:data][:weather][:attributes][:city_name]).to eq ("Denver")
          expect(weather_music[:data][:weather][:attributes][:country_name]).to eq ("US")
        end

      it 'adds a playlist to users library', :vcr do
          playlist_name = "party name"
          tracks = "[\"spotify:track:4mYG4iHgfxlPaqfT3BQ0ec\", \"spotify:track:1Bj6YgjjPbEb4jhQ50T8tJ\", \"spotify:track:6qspW4YKycviDFjHBOaqUY\", \"spotify:track:12G1TYIfbpvC0mdFFn4Pbg\", \"spotify:track:6gJdDnF2TzfA1WPMXuCa3x\", \"spotify:track:7sJN693sYKEIEMu7fc5VnJ\", \"spotify:track:2vytyWClpsahqcL6NibSE3\", \"spotify:track:4Yenz5JZZOUiZSeyKY8bDz\", \"spotify:track:3jpaB4JCMidb5XshQtDSGm\", \"spotify:track:7KFThZQCAcj8JXdPRtdrXE\", \"spotify:track:5vWwuFTSoPdyY8rH1mui8W\", \"spotify:track:4o6BgsqLIBViaGVbx5rbRk\", \"spotify:track:24PWKmemCvqfyVXODhoKHW\", \"spotify:track:4O4Z8VFczL8MxIOmqVWc1b\", \"spotify:track:3whRKAOlJ0M3banzcChvQv\", \"spotify:track:4aOjDKk1s5hlsEY5ZhhX3l\", \"spotify:track:5krOROgmf8adn3SJzeKLZy\", \"spotify:track:0qRR9d89hIS0MHRkQ0ejxX\", \"spotify:track:5LxvwujISqiB8vpRYv887S\", \"spotify:track:1GrikfH0jDejDvrxo84n4P\"]"

          post "/add_playlist_to_library?playlist_name=#{playlist_name}&user_id=#{@user_id}&tracks=#{tracks}&token=#{@token}"
          expect(last_response).to be_successful
          expect(last_response.content_type).to eq('application/json')
          response = JSON.parse(last_response.body, symbolize_names: true)
          expect(response).to be_a(Hash)
          expect(response[:data][:playlist][:attributes]).to have_key :status
          expect(response[:data][:playlist][:attributes]).to have_key :external_url
        end
      end
