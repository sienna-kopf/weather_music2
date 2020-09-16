require_relative "spec_helper"

def app
  WeatherMusicController
end

describe WeatherMusicController do
  it "returns current weather data for a particular location city, state, country" do
    VCR.use_cassette('weather_city_state_country') do
      location = "denver, co, usa"
      token = "BQCUWpH1zKfALk8giUlS1bT3GzIeaWyqhGEjree-BlwcmFrllOZlN0I-mLIiwWZQSFOHZROn_1I8rvk_GYjYxUDV9i4g9tLx69ywT8-aBDVz7uonPEbrEjD1cHs6cflze9JdlxXMvkiTgDwW01y66WpyWJfV0ipL689I7_FGCD6MHcgBbxtVX5w5DJrcNXQHtDF6ycIk12cJWGDqX7e3abys2dJH_UDq_Obkn5ZYEH1LUPQ"
      get "/weather_playlist?units=imperial&q=#{location}&token=#{token}"

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
  end

  it "returns current weather data for a particular location city, country" do
    VCR.use_cassette('weather_city_country') do
      location = "santiago, chi"
      token = "BQCUWpH1zKfALk8giUlS1bT3GzIeaWyqhGEjree-BlwcmFrllOZlN0I-mLIiwWZQSFOHZROn_1I8rvk_GYjYxUDV9i4g9tLx69ywT8-aBDVz7uonPEbrEjD1cHs6cflze9JdlxXMvkiTgDwW01y66WpyWJfV0ipL689I7_FGCD6MHcgBbxtVX5w5DJrcNXQHtDF6ycIk12cJWGDqX7e3abys2dJH_UDq_Obkn5ZYEH1LUPQ"
      get "/weather_playlist?units=imperial&q=#{location}&token=#{token}"

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
  end

  it "returns current weather data for a particular location city" do
    VCR.use_cassette('weather_city') do
      location = "salt lake city"
      token = "BQCUWpH1zKfALk8giUlS1bT3GzIeaWyqhGEjree-BlwcmFrllOZlN0I-mLIiwWZQSFOHZROn_1I8rvk_GYjYxUDV9i4g9tLx69ywT8-aBDVz7uonPEbrEjD1cHs6cflze9JdlxXMvkiTgDwW01y66WpyWJfV0ipL689I7_FGCD6MHcgBbxtVX5w5DJrcNXQHtDF6ycIk12cJWGDqX7e3abys2dJH_UDq_Obkn5ZYEH1LUPQ"
      get "/weather_playlist?units=imperial&q=#{location}&token=#{token}"

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
  end

  it "returns an error message if location cannot be found" do
    VCR.use_cassette('invalid location input') do
      location = "aowfufrbjna"
      token = "BQCUWpH1zKfALk8giUlS1bT3GzIeaWyqhGEjree-BlwcmFrllOZlN0I-mLIiwWZQSFOHZROn_1I8rvk_GYjYxUDV9i4g9tLx69ywT8-aBDVz7uonPEbrEjD1cHs6cflze9JdlxXMvkiTgDwW01y66WpyWJfV0ipL689I7_FGCD6MHcgBbxtVX5w5DJrcNXQHtDF6ycIk12cJWGDqX7e3abys2dJH_UDq_Obkn5ZYEH1LUPQ"
      get "/weather_playlist?units=imperial&q=#{location}&token=#{token}"

      expect(last_response).to be_successful
      last_response.content_type == "application/json"

      error = JSON.parse(last_response.body, symbolize_names: true)

      expect(error).to be_a Hash
      expect(error[:data][:attributes]).to have_key :code
      expect(error[:data][:attributes]).to have_key :message
      expect(error[:data][:attributes][:code]).to eq(404)
      expect(error[:data][:attributes][:message]).to eq("city_not_found")
    end
  end
end
