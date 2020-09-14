ENV["SINATRA_ENV"] = "test"
require 'simplecov'
SimpleCov.start

require_relative '../config/environment'
require 'rack/test'
require 'capybara/rspec'
require 'capybara/dsl'
require 'webmock/rspec'

# Capybara.app = WeatherMusicController
Capybara.save_path = 'tmp/capybara'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.include Rack::Test::Methods
  config.include Capybara::DSL

  config.order = 'default'
end

def app
  Rack::Builder.parse_file('config.ru').first
end

Capybara.app = app

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.filter_sensitive_data('WEATHER_API_KEY') { ENV['WEATHER_API_KEY'] }
  config.configure_rspec_metadata!
  config.allow_http_connections_when_no_cassette = true
end
