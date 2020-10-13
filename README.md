# Weather_Music2

## About: 
Sinatra micro-service to handle API calls and data synthesis for the user facing Ruby on Rails application, [WeatherBop](https://github.com/neeruram1/weatherbop). Part of an 11- day sprint from project inception to completion. All goals for the functionality of this application were met by the deadline! </br>

From a user inputted location, this application retrieves specific weather data and associates the present weather attributes to track audio attributes in order to return a curated list of tracks. This application also handles playlist creation functionality in which the recommended tracks are aggregated into a cleverly named playlist in the users Spotify library. 
- weather data retrieved from the Open Weather API 
- curated track list and playlist creation handled utilizing the Spotify API

## Setup:
- clone and setup locally
- `bundle install`

### API Key Configuration: 
Run `touch .env` to trigger the creation of a `/.env` file for configuring API keys. </br>

Sign up for the following API: </br>
[OpenWeather](https://home.openweathermap.org/users/sign_up)</br>
Add the following code snippet to your `/.env` file.      </br> 
Make sure to insert the key without the alligator clips ( < > ).</br>
```
WEATHER_API_KEY=<insert>
```

## Testing: 
The `weather_music2` application is fully tested using RSpec reporting ~100% test coverage determined by SimpleCov. To run the test suite, setup the application and run `bundle exec rspec` in the terminal. To run a specific test run `bundle exec rspec <test file path>`. To open the coverage report generated by SimpleCov run `open coverage/index.html`.

## Tools:
- Sinatra
- Corneal
- dotenv
- Faraday
- FastJsonAPI
- Bcrypt
- VCR 
- WebMock
- RSpec
- Pry
- Launchy
- Capybara
- SimpleCov
- Spotify API
- OpenWeather API
- GitHub & GitHub Projects

## Authors:

[Sienna Kopf](https://github.com/sienna-kopf)</br>
[Neeru Ram](https://github.com/neeruram1)   </br>     
[Ashkan Abbasi](https://github.com/ashkanthegreat)   </br>
[Joshua Tukman](https://github.com/joshua-tukman)</br>

