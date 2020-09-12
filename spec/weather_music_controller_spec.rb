require_relative "spec_helper"

def app
  WeatherMusicController
end

describe WeatherMusicController do
  it "returns current weather data for a particular location city, state, country" do
    VCR.use_cassette('weather_city_state_country') do
      location = "denver, co, usa"

      get "/weather_playlist?units=imperial&q=#{location}"

      expect(last_response).to be_successful
      last_response.content_type == "application/json"

      weather = JSON.parse(last_response.body, symbolize_names: true)

      expect(weather).to be_a Hash
      expect(weather).to have_key :city_name
      expect(weather).to have_key :country_name
      expect(weather).to have_key :sunrise_time
      expect(weather).to have_key :sunset_time
      expect(weather).to have_key :description
      expect(weather).to have_key :temp
      expect(weather).to have_key :temp_min
      expect(weather).to have_key :temp_max
      expect(weather).to have_key :pressure
      expect(weather).to have_key :humidity
      expect(weather).to have_key :visibility
      expect(weather).to have_key :wind

      expect(weather[:city_name]).to eq("Denver")
      expect(weather[:country_name]).to eq("US")
    end
  end

  it "returns current weather data for a particular location city, country" do
    VCR.use_cassette('weather_city_country') do
      location = "santiago, chi"

      get "/weather_playlist?units=imperial&q=#{location}"

      expect(last_response).to be_successful
      last_response.content_type == "application/json"

      weather = JSON.parse(last_response.body, symbolize_names: true)

      expect(weather).to be_a Hash
      expect(weather).to have_key :city_name
      expect(weather).to have_key :country_name
      expect(weather).to have_key :sunrise_time
      expect(weather).to have_key :sunset_time
      expect(weather).to have_key :description
      expect(weather).to have_key :temp
      expect(weather).to have_key :temp_min
      expect(weather).to have_key :temp_max
      expect(weather).to have_key :pressure
      expect(weather).to have_key :humidity
      expect(weather).to have_key :visibility
      expect(weather).to have_key :wind

      expect(weather[:city_name]).to eq("Santiago")
      expect(weather[:country_name]).to eq("CL")
    end
  end

  it "returns current weather data for a particular location city" do
    VCR.use_cassette('weather_city') do
      location = "salt lake city"

      get "/weather_playlist?units=imperial&q=#{location}"

      expect(last_response).to be_successful
      last_response.content_type == "application/json"

      weather = JSON.parse(last_response.body, symbolize_names: true)

      expect(weather).to be_a Hash
      expect(weather).to have_key :city_name
      expect(weather).to have_key :country_name
      expect(weather).to have_key :sunrise_time
      expect(weather).to have_key :sunset_time
      expect(weather).to have_key :description
      expect(weather).to have_key :temp
      expect(weather).to have_key :temp_min
      expect(weather).to have_key :temp_max
      expect(weather).to have_key :pressure
      expect(weather).to have_key :humidity
      expect(weather).to have_key :visibility
      expect(weather).to have_key :wind

      expect(weather[:city_name]).to eq("Salt Lake City")
      expect(weather[:country_name]).to eq("US")
    end
  end

  it "returns an error message if location cannot be found" do
    location = "aowfufrbjna"

    get "/weather_playlist?units=imperial&q=#{location}"

    expect(last_response).to be_successful
    last_response.content_type == "application/json"

    error = JSON.parse(last_response.body, symbolize_names: true)

    expect(error).to be_a Hash
    expect(error).to have_key :code
    expect(error).to have_key :message
    expect(error[:code]).to eq(404)
    expect(error[:message]).to eq("city_not_found")
  end
end
