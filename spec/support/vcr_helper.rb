require 'httpi'
require 'savon'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
  #c.default_cassette_options = { :record => :new_episodes }
  #http://stackoverflow.com/questions/20667642/rspec-savon-vcr-not-recording
  c.ignore_hosts 'pim.sredda.ru'
  c.configure_rspec_metadata!
  c.ignore_localhost                        = true
  c.allow_http_connections_when_no_cassette = true
  c.default_cassette_options                = { 
    record: :new_episodes, 
    allow_playback_repeats: true, 
    match_requests_on: [:method, :uri, :headers, :body] 
  }
end
