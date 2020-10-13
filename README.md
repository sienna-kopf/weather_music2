# weather_music2

## About: 
Sinatra micro-service to handle API calls and data synthesis for the user facing Ruby on Rails application, [WeatherBop](https://github.com/neeruram1/weatherbop). Part of an 11- day sprint from project inception to completion. All goals for the functionality of this application were met by the deadline! 

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
OPEN_WEATHER_API_KEY=<insert>
```

Sign Up on the following API:   </br>
[Spotify](https://developer.spotify.com/documentation/web-api/quick-start/)   </br>
Add the following code snippet to your config/application.yml file in weatherbop.    </br>
Make sure to insert the key/secret without the alligator clips ( < > ). </br>

```
SPOTIFY_CLIENT_ID: <insert>
SPOTIFY_CLIENT_SECRET: <insert>
```

