require 'spec_helper'

describe WeatherMusicSerializer do
  it 'data_hash' do
    weather_attrs = {
      :weather=>[{:id=>801, :main=>"Clouds", :description=>"few clouds", :icon=>"02d"}],
      :base=>"stations",
      :main=>{:temp=>50.38, :feels_like=>43.48, :temp_min=>46.99, :temp_max=>54, :pressure=>1021, :humidity=>57},
      :visibility=>10000,
      :wind=>{:speed=>6.93, :deg=>190},
      :clouds=>{:all=>20},
      :dt=>1599919477,
      :sys=>{:type=>1, :id=>3449, :country=>"US", :sunrise=>1599914329, :sunset=>1599959606},
      :timezone=>-21600,
      :id=>5419384,
      :name=>"Denver",
      :cod=>200
    }

    playlist_attrs = {:playlists=>
      {:items=>
        [
          {
          :id=>"1VT0GnhelpcB9qtnGo70rv",
          :uri=>"spotify:playlist:1VT0GnhelpcB9qtnGo70rv"
        }
        ]
      }
    }

    forecast = Forecast.new(weather_attrs)
    playlist = Playlist.new(playlist_attrs)
    weather_music = WeatherMusicSerializer.new(forecast, playlist).data_hash

     expect(weather_music).to be_a Hash
     expect(weather_music[:data][:weather][:attributes]).to have_key :city_name
     expect(weather_music[:data][:weather][:attributes]).to have_key :country_name
     expect(weather_music[:data][:weather][:attributes]).to have_key :sunrise_time
     expect(weather_music[:data][:weather][:attributes]).to have_key :sunset_time
     expect(weather_music[:data][:weather][:attributes]).to have_key :description
     expect(weather_music[:data][:weather][:attributes]).to have_key :temp
     expect(weather_music[:data][:weather][:attributes]).to have_key :temp_min
     expect(weather_music[:data][:weather][:attributes]).to have_key :temp_max
     expect(weather_music[:data][:weather][:attributes]).to have_key :pressure
     expect(weather_music[:data][:weather][:attributes]).to have_key :humidity
     expect(weather_music[:data][:weather][:attributes]).to have_key :visibility
     expect(weather_music[:data][:weather][:attributes]).to have_key :wind
     expect(weather_music[:data][:weather][:attributes]).to have_key :main_description
     expect(weather_music[:data][:weather][:attributes]).to have_key :icon

     expect(weather_music[:data][:music][:attributes]).to have_key :id
     expect(weather_music[:data][:music][:attributes]).to have_key :uri
  end

  it "no_city" do
    weather_music = WeatherMusicSerializer.new.no_city_response
    expect(weather_music).to be_a Hash
    expect(weather_music[:data][:attributes]).to have_key :code
    expect(weather_music[:data][:attributes]).to have_key :message
    expect(weather_music[:data][:attributes][:code]).to eq(404)
    expect(weather_music[:data][:attributes][:message]).to eq("city_not_found")
  end

  it "no_playlist" do
    weather_music = WeatherMusicSerializer.new.no_playlist_response
    expect(weather_music).to be_a Hash
    expect(weather_music[:data][:attributes]).to have_key :code
    expect(weather_music[:data][:attributes]).to have_key :message
    expect(weather_music[:data][:attributes][:code]).to eq(404)
    expect(weather_music[:data][:attributes][:message]).to eq("playlist_not_found")
  end
end
