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
end
