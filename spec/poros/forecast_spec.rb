require 'spec_helper'

describe Forecast do
  it 'exists' do
    attrs = {
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

    forecast = Forecast.new(attrs)

    expect(forecast).to be_a Forecast
    expect(forecast.city_name).to eq("Denver")
    expect(forecast.country_name).to eq("US")
    expect(forecast.sunrise_time).to eq(1599914329)
    expect(forecast.sunset_time).to eq(1599959606)
    expect(forecast.description).to eq("few clouds")
    expect(forecast.icon).to eq("02d")
    expect(forecast.temp).to eq(50)
    expect(forecast.temp_min).to eq(47)
    expect(forecast.temp_max).to eq(54)
    expect(forecast.pressure).to eq(1021)
    expect(forecast.humidity).to eq(57)
    expect(forecast.visibility).to eq(10000)
    expect(forecast.wind).to eq(6.93)
  end
end
