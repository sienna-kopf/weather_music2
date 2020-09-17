require './config/environment'
require 'dotenv'
Dotenv.load

class WeatherMusicController < ApplicationController
  before do
    content_type 'application/json'
  end

  get "/weather_playlist" do
    serialization(WeatherService.new.forecast(params[:q]), params[:token])
  end

  post "/add_playlist_to_library" do
    playlist(params[:playlist_name], params[:user_id], params[:tracks], params[:token])
  end
end
